<?php
class conf_ApplicationDelegate {
  function beforeHandleRequest() {
    Dataface_Application::getInstance()->addHeadContent(
      '<link rel="stylesheet" type="text/css" href="style.css"/>');
  }

  function getPermissions(&$Record) {
    $auth =& Dataface_AuthenticationTool::getInstance();
    $user =& $auth->getLoggedInUser();
    // this will force a login prompt
    if (!isset($user)) return Dataface_PermissionsTool::NO_ACCESS();
    $role = $user->val('role');
    // returns all of the permissions for the users's current role or NO_ACCESS
    if (isset($role)) {
      return Dataface_PermissionsTool::getRolePermissions($role);
    } else {
      return Dataface_PermissionsTool::NO_ACCESS();
    }
  }
}
?>
