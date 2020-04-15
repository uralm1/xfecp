<?php
class tables_skzi_assignments {
  
  function getTitle(&$record) {
    switch ($record->val('state')) {
    case 1: $st = 'Установка '; break;
    case 2: $st = 'Обновление '; break;
    case 3: $st = 'Удаление '; break;
    case 4: $st = 'Смена пользователя '; break;
    default: $st = '';
    }
    return $st.'СКЗИ:'.$record->val('skzi').' -> '.$record->val('user_to').' ('.$record->val('arm_hostname').')';
  }

  function date_assignment__display(&$record) {
    return date('d/m/Y H:i', strtotime($record->strval('date_assignment')));
  }
}
?>
