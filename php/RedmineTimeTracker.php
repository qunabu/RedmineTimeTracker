<?php
require 'vendor/autoload.php';
require("RedmineTimeTrackerConfig.php");
class RedmineTimeTracker {

	public static $username;
	public static $password;
	public static $redmine_url;
	public static $tracked_status;
	private $context;
	private $smarty;
	private $issues = array();
	private $issues_by_users_projects = array();
	private $projects = array();
	private $users = array();
	private $start_date;
	private $end_date;

	public function __construct() {
		if (!isset(self::$username)) {
			throw new Exception("username must be set", 1);			
		}
		if (!isset(self::$password)) {
			throw new Exception("password must be set", 1);			
		}
		if (!isset(self::$redmine_url)) {
			throw new Exception("redmine_url must be set", 1);			
		}
		if (!isset(self::$tracked_status)) {
			throw new Exception("tracked_status must be set", 1);			
		}
		$this->context = stream_context_create(array(
		    'http' => array(
		        'header'  => "Authorization: Basic " . base64_encode(self::$username.":".self::$password)
		    )
		));
		if (isset($_GET['start_date']) && isset($_GET['end_date'])) {
			$this->start_date = $_GET['start_date'];
			$this->end_date = $_GET['end_date'];
		} else {
			$this->start_date = date('Y-m-d', strtotime('first day of previous month'));
			$this->end_date = date('Y-m-d', strtotime('last day of previous month'));
		}

		$this->initSmarty();		
	}

	private function initSmarty() {
		$this->smarty = new Smarty();
		$this->smarty->setTemplateDir('smarty/templates');
		$this->smarty->setCompileDir('smarty/templates_c');
		$this->smarty->setCacheDir('smarty/cache');
		$this->smarty->setConfigDir('smarty/configs');
	}

	private function getIssuesByUsersAndProjects() {
		$data = array();
		foreach ($this->issues as $issue_id => $issue) {
			foreach ($this->users as $user_id => $username) {
				foreach($this->projects as $project_id => $project_name) {
					foreach($issue['changes'] as $change) {
						//trace($issue);
						if (
							$change['user_id'] == $user_id 
							&& $issue['project_id'] == $project_id
							) 
						{
							if (!isset($data[$user_id])) {
								$data[$user_id] = array(
									'username' => $username,
									'user_id'  => $user_id,
									'projects' => array(),
									'time' => 0
								);
							}
							if (!isset($data[$user_id]['projects'][$project_id])) {
								$data[$user_id]['projects'][$project_id] = array(
									'project_name'=> $project_name,
									'issues' => array(),
									'time' => 0			
								);
							}
							if (!isset($data[$user_id]['projects'][$project_id]['issues'][$issue_id])) {
								$data[$user_id]['projects'][$project_id]['issues'][$issue_id] = array(
									'data'=> $issue,
									'time'=> 0,
									'changes' => array()			
								);
							}
							$data[$user_id]['projects'][$project_id]['issues'][$issue_id]['data'] = $issue;
							$data[$user_id]['projects'][$project_id]['issues'][$issue_id]['changes'][] = $change;

							$time = $change['time'];

							$data[$user_id]['time'] += $time;
							$data[$user_id]['projects'][$project_id]['time'] += $time;
							$data[$user_id]['projects'][$project_id]['issues'][$issue_id]['time'] += $time;;

							//$data[$user_id]['projects'][$project_id]['changes'][] = $change;
						}
					}
				}
			}
		}
		//trace($data);
		return $data;
	}

	public function render() {
		$this->issues_by_users_projects = $this->getIssuesByUsersAndProjects();
		$this->smarty->assign('issues_by_users_projects', $this->issues_by_users_projects);
		$this->smarty->assign('issues', $this->issues);
		$this->smarty->assign('redmine_url', self::$redmine_url);
		$this->smarty->assign('start_date', $this->start_date);
		$this->smarty->assign('end_date', $this->end_date);
		return $this->smarty->display('index.tpl');
	}


	private function getJSONFile($url) {
		$cached_file = 'cache/'.str_replace(array('/','?','&','=','%','.','|'),'_', $url);
		if (is_file($cached_file))	{
			$data = file_get_contents($cached_file);
			if ($data=='') {
				//empty file;
				//delete and download
				unlink($cached_file);
				return $this->getJSONFile($url);
			}
		} else {
			$url = self::$redmine_url.$url;
			$data = file_get_contents($url, false, $this->context);
			if ($data =='') {
				trace($data);
				throw new Exception("Error Processing Request", 1);
			} else {
				file_put_contents($cached_file, $data);
			}
		}
		return json_decode($data, false);
	}

	public function getIssues($start_date = null, $end_date = null) {
		//$start_date = '2015-03-01';
		//$end_date = '2015-03-28';
		if ($start_date==null) { $start_date = $this->start_date; }
		if ($end_date==null) { $end_date = $this->end_date; }
		$url = 'issues.json?updated_on=%3E%3C'.$start_date.'|'.$end_date.'&limit=1000';
		$data = $this->getJSONFile($url);
		foreach ($data->issues as $issue) {
			$this->projects[$issue->project->id] = $issue->project->name;
			$issue_data = $this->getJSONFile('/issues/'.$issue->id.'.json?include=journals');			
			$time_data = $this->onIssueTime($issue_data);
			$this->issues[$issue->id] = array(
				'data'=>$issue_data,
				'id'=>$issue->id,
				'subject'=>$issue->subject,
				'status'=>$issue->status->name,
				'project'=>$issue->project->name,
				'project_id'=>$issue->project->id,
				'start_date'=>$issue->start_date,
				'time' => $time_data['time'],
				'changes' => $time_data['changes'],
				'link'=> self::$redmine_url.'issues/'.$issue->id
			);
		}
	}

	private function onIssueTime($data) {
		$journals = $data->issue->journals;
		$id = $data->issue->id;
		$created_on = $data->issue->created_on;
		$time = 0;
		$changes = array();
		
		for ($i=0; $i < count($journals); $i++) {
			$journal = $journals[$i];		
			for ($j=0; $j < count($journal->details); $j++) {
				$detail = $journal->details[$j];
				if ($detail->name=="status_id") {
					if ($detail->old_value=="3") {						
						if ($i!=0) {
							/** TODO check against start and end date */
							$this_time = strtotime($journals[$i]->created_on);
							$prev_time = strtotime($journals[$i-1]->created_on);
							$user = $journals[$i-1]->user->name;	
							$diff_time = ($this_time - $prev_time)/3600;
							$time = $time + $diff_time;
							$changes[] = array(
								'start_time'=>date('m-d H:i',$prev_time),
								'end_time'=>date('m-d H:i',$this_time),
								'user'=>$journals[$i-1]->user->name,
								'user_id'=>$journals[$i-1]->user->id,
								'time'=>$diff_time
							);
							$this->users[$journals[$i-1]->user->id] = $journals[$i-1]->user->name;
						} else {
							/** TODO check against start and end date */
							//check agains created date
						}
					}
				} 
			}
		}
		return array(
			'time'=> $time,
			'changes' => $changes,
		);
	}

	public function clearCache() {
		$files = glob('cache/*');
		foreach($files as $file){ // iterate files
		  if(is_file($file)) {
		    unlink($file); // delete file
		  }
		}
	}
	



}

function trace() {
	echo '<pre>';
	var_dump(func_get_args());
	echo '</pre>';
}

//$table = 'hi';