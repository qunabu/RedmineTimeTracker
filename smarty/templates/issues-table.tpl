{foreach from=$issues_by_users_projects item=issueUP}

<div role="tabpanel" class="tab-pane active" id="user{$issueUP.user_id}">

  {foreach from=$issueUP.projects item=project}

    <div class="page-header">
      <h2>{$project.project_name} <small>(time:{$project.time|string_format:"%.2f"}h)</small></h2>
    </div>  

  <div class="well">
     <table id="issues" class="table table-bordered">
      <thead>
        <tr>
          <th>Id</th>
          <th>Name</th>
          <th>Start Date</th>
          <th>Status</th>
          <th>Changes</th>
          <th>Time (h)</th>
        </tr>
      </thead>
      <tbody>
         {foreach from=$project.issues item=issue}
           <tr>
            <td><a href="{$issue.data.link}" target="_blank">{$issue.data.id}</a></td>
            <td><a href="{$issue.data.link}" target="_blank">{$issue.data.subject}</a></td>
            <td>{$issue.data.start_date}</td>
            <td>{$issue.data.status}</td>
            <td>
              <ul>
              {foreach from=$issue.changes item=change}
                <li>
                  <small>
                    <strong>{$change.time|string_format:"%.2f"}h</strong> {$change.start_time} - {$change.end_time} 
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