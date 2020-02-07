package team.abc.ssm.modules.document.journal.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.modules.document.journal.dao.JournalDao;
import team.abc.ssm.modules.document.journal.entity.Journal;
import team.abc.ssm.modules.sys.entity.User;

import java.util.Date;
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

    public void updateJournal(Journal journal){
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        journal.setModifyDate(dateNow);
        journal.setModifyUserId(userNow.getId());

        journalDao.updateJournal(journal);
    }
}
