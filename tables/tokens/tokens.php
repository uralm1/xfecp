<?php
class tables_tokens {
  
  function getTitle(&$record) {
    return 'Носитель: '.$record->val('type').' '.$record->val('sn');
  }

  function titleColumn() {
    return "CONCAT_WS(' ', type, sn)";
  }
}
?>
