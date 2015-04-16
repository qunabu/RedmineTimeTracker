<!DOCTYPE html>
<!--[if lt IE 7]      <html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->
<!--[if IE 7]         <html class="no-js lt-ie9 lt-ie8"><![endif]-->
<!--[if IE 8]         <html class="no-js lt-ie9"><![endif]-->
<!--[if gt IE 8]<!--> <html class="no-js"> <!--<![endif]-->
<head>
  {include file='header.tpl'}
</head>



<body>
  <!--[if lt IE 7]>
  <p class="browsehappy">
    You are using an <strong>outdated</strong> browser. Please<a href="http://browsehappy.com/">Upgrade your browser to improve your experience</a>
  </p>
  <![endif]-->

  <div class="container">
  	<div class="page-header">
  		<h1>Redmine Time Tracker <small>for {$redmine_url}</small></h1>
	</div>

	<form class="form-inline text-right" method="get">
	  <div class="form-group">
	    <label for="start_date">Start Date</label>
	    <input type="date" name="start_date" class="form-control" id="start_date" placeholder="Start Date" value="{$start_date}">
	  </div>
	  <div class="form-group">
	    <label for="end_date">End Date</label>
	    <input type="date" name="end_date" class="form-control" id="end_date" placeholder="End Date" value="{$end_date}">
	  </div>
	  <button type="submit" class="btn btn-default">Change</button>
	  <a class="btn btn-default" href="?clear-cache" role="button">Clear cache</a>
	</form>


	<hr/>

	{if empty($issues_by_users_projects)}
		<div class="alert alert-warning text-center" role="alert">No issues found</div>
	{else}
  	<div role="tabpanel">
		<ul class="nav nav-tabs" role="tablist">
	  	{foreach from=$issues_by_users_projects item=issueUP name=foo}
		<li role="presentation" class="{if $smarty.foreach.foo.first}active{/if}">
			<a href="#user{$issueUP.user_id}" aria-controls="user{$issueUP.user_id}" role="tab" data-toggle="tab">	
				{$issueUP.username}
				<small>({$issueUP.time|string_format:"%.2f"}h)</small>
			</a>
		</li>
	  	{/foreach}
	  	</ul>
  	</div>

  	<div class="tab-content">
    	{include file='issues-table.tpl'}
	</div>
	{/if}
  </div>

</body>
</html>