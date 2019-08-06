package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.doc.dao.JournalDao;
import team.abc.ssm.modules.doc.entity.Journal;

import java.util.List;

@Service
public class JournalService {

    @Autowired
    private JournalDao journalDao;

    public Page<Journal> list(Journal journal){
        Page<Journal> page = new Page<>();
        page.setResultList(journalDao.list(journal));
        page.setTotal(journalDao.listCount(journal));
        return page;
    }

    public void deleteByIds(List<Journal> list){
        journalDao.deleteByIds(list);
    }

    public void deleteAll(){
        journalDao.deleteAll();
    }
}
