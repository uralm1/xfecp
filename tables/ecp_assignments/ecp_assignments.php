<?php
class tables_ecp_assignments {
  
  function getTitle(&$record) {
    switch ($record->val('state')) {
    case 1: $st = 'Выдача '; break;
    case 2: $st = 'Сдача '; break;
    case 3: $st = 'Удаление'; break;
    default: $st = '';
    }
    return $st.'ЭЦП:'.$record->val('ecp').' -> '.$record->val('user_to').' (роспись:'.$record->val('rec_no').')';
  }

  function date_assignment__display(&$record) {
    return date('d/m/Y H:i', strtotime($record->strval('date_assignment')));
  }
}
?>
