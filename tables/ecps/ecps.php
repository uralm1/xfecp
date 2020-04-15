<?php
class tables_ecps {
  
  function getTitle(&$record) {
    if (!empty($record->val('owner_ul'))) {
      return $record->val('owner_ul').'/'.$record->val('owner_fl').' '.$record->val('issuer').' '.$record->display('date_issue');
    } else {
      return $record->val('owner_fl').' '.$record->val('issuer').' '.$record->display('date_issue');
    }
  }

  function date_issue__display(&$record) {
    return date('d/m/Y', strtotime($record->strval('date_issue')));
  }
  function date_end__display(&$record) {
    return date('d/m/Y', strtotime($record->strval('date_end')));
  }
}
?>
