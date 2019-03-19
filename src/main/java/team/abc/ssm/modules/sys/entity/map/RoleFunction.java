package team.abc.ssm.modules.sys.entity.map;

import team.abc.ssm.common.persistence.DataEntity;

public class RoleFunction extends DataEntity<RoleFunction> {

    private String roleId;
    private String functionId;

    public String getFunctionId() {
        return functionId;
    }

    public void setFunctionId(String functionId) {
        this.functionId = functionId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}
