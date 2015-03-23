  <?php 
  	require "php/RedmineTimeTracker.php"; 
  	$rtt = new RedmineTimeTracker();
  	if (isset($_GET['clear-cache'])) {
  		$rtt->clearCache();
  	}
  	$rtt->getIssues();
  	$rtt->render();
  ?>