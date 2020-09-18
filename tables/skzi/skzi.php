<?php
class tables_skzi {
  
  function getTitle(&$record) {
    return $record->val('name').' '.$record->val('sn');
  }

  function titleColumn() {
    return "CONCAT_WS(' ', name, sn)";
  }
}
?>
