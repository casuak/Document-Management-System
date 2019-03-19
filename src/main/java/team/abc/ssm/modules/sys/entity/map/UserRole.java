package team.abc.ssm.modules.sys.entity.map;

import team.abc.ssm.common.persistence.DataEntity;


public class UserRole extends DataEntity<UserRole> {
    private String userId;
    private String roleId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}
