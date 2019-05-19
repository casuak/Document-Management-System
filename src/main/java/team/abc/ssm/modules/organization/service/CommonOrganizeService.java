package team.abc.ssm.modules.organization.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.organization.dao.CommonOrganizeMapper;

import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description
 * @data 2019/4/16
 */
@Service
public class CommonOrganizeService {

    @Autowired
    private CommonOrganizeMapper orgMapper;

    /** 获取orglistmap候选项*/
    public List<String> getOrgList(){

        return orgMapper.getOrgList();
    }
}
