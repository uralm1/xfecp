<?php
class tables_tokens {
  
  function getTitle(&$record) {
    return 'Носитель: '.$record->val('type').' '.$record->val('sn');
  }
}
?>
