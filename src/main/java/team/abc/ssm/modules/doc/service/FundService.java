package team.abc.ssm.modules.doc.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.doc.dao.FundDao;
import team.abc.ssm.modules.doc.entity.Fund;

@Service
public class FundService {

    @Autowired
    private FundDao fundDao;

    public Page<Fund> list(Fund fund){
        Page<Fund> page = new Page<>();
        page.setResultList(fundDao.list(fund));
        page.setTotal(fundDao.listCount(fund));
        return page;
    }

    public void deleteByIds(List<Fund>list){
        fundDao.deleteByIds(list);
    }

    public void deleteAll(){fundDao.deleteAll();};

    public void updateById(Fund fund){
        fund.preUpdate();
        fundDao.updateById(fund);
    }
}
