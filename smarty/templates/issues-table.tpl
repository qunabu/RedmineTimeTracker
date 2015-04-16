<!--
{foreach from=$issues_by_users_projects item=issueUP name=projects}

<div role="tabpanel" class="tab-pane {if $smarty.foreach.projects.first}active{/if}" id="user{$issueUP.user_id}">

  {foreach from=$issueUP.projects item=project key=project_id}

  <div class="page-header">
    <h2>{$project.project_name} <small>(time:{$project.time|string_format:"%.2f"}h)</small></h2>
  </div>

  <div class="well">
     <table id="issues{$issueUP.user_id}_{$project.project_id}" class="table table-striped table-condensed">
      <thead>
        <tr>
          <th>Id</th>
          <th>Name</th>
          <th>Start Date</th>
          <th>Current Status</th>
          <th>Changes</th>
          <th>Time (h)</th>
        </tr>
      </thead>
      <tbody>
         {foreach from=$project.issues item=issue}
           <tr {if $issue.error}class="danger"{/if}>
            <td><a href="{$issue.data.link}" target="_blank">{$issue.data.id}</a></td>
            <td><a href="{$issue.data.link}" target="_blank">{$issue.data.subject}</a></td>
            <td>{$issue.data.start_date}</td>
            <td>{$issue.data.status}</td>
            <td>
              <ul>
              {foreach from=$issue.changes item=change}
                <li>
                  <small>
                    <strong>{$change.time|string_format:"%.2f"}h</strong> {$change.start_time} - {$change.end_time} {if $change.error}<span class="label label-danger">{$change.error}</span>{/if}
                  </small>
                </li>
              {/foreach} 
              <ul>
            </td>
            <td>{$issue.time|string_format:"%.2f"}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
  {/foreach}

</div>

{/foreach}
-->

{foreach from=$issues_by_users_projects item=issueUP name=projects}

  <div role="tabpanel" class="tab-pane {if $smarty.foreach.projects.first}active{/if}" id="user{$issueUP.user_id}">

    <div class="panel-group" id="accordion{$issueUP.user_id}" role="tablist" aria-multiselectable="true">

      <p>&nbsp;</p>

      {foreach from=$issueUP.projects item=project key=project_id name=issues}

        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading{$issueUP.user_id}_{$project_id}">
            <h4 class="panel-title">
              <a data-toggle="collapse" data-parent="#accordion{$issueUP.user_id}_{$project_id}" href="#collapse{$issueUP.user_id}_{$project_id}" aria-expanded="true" aria-controls="collapse{$issueUP.user_id}_{$project_id}">
                {$project.project_name}
                <small>(time:{$project.time|string_format:"%.2f"}h)</small>
                {if $project.error}<span class="label label-danger">Errors</span>{/if}
              </a>
            </h4>
          </div>
          <div id="collapse{$issueUP.user_id}_{$project_id}" class="panel-collapse collapse {if $smarty.foreach.issues.first}__in{/if}" role="tabpanel" aria-labelledby="heading{$issueUP.user_id}_{$project_id}">
            <div class="panel-body">

              <table id="issues{$issueUP.user_id}_{$project.project_id}" class="table table-striped table-condensed">
                <thead>
                <tr>
                  <th>Id</th>
                  <th>Name</th>
                  <th>Start Date</th>
                  <th>Current Status</th>
                  <th>Changes</th>
                  <th>Time (h)</th>
                </tr>
                </thead>
                <tbody>
                {foreach from=$project.issues item=issue}
                  <tr {if $issue.error}class="danger"{/if}>
                    <td><a href="{$issue.data.link}" target="_blank">{$issue.data.id}</a></td>
                    <td><a href="{$issue.data.link}" target="_blank">{$issue.data.subject}</a></td>
                    <td>{$issue.data.start_date}</td>
                    <td>{$issue.data.status}</td>
                    <td>
                      <ul>
                        {foreach from=$issue.changes item=change}
                          <li>
                            <small>
                              <strong>{$change.time|string_format:"%.2f"}h</strong> {$change.start_time} - {$change.end_time} {if $change.error}<span class="label label-danger">{$change.error}</span>{/if}
                            </small>
                          </li>
                        {/foreach}
                        <ul>
                    </td>
                    <td>{$issue.time|string_format:"%.2f"}</td>
                  </tr>
                {/foreach}
                </tbody>
              </table>

            </div>
          </div>
        </div>

      {/foreach}

    </div>

  </div>

{/foreach}