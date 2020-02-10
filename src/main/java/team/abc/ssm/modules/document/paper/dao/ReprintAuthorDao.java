package team.abc.ssm.modules.document.paper.dao;

import team.abc.ssm.modules.document.paper.entity.Paper;
import team.abc.ssm.modules.document.paper.entity.ReprintAuthorEntry;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface ReprintAuthorDao {
    List<Paper> selectListByPage(Paper paper);

    int selectSearchCount(Paper paper);

    List<Paper> getPaperByStatus(String status);

    void updatePaperById(Paper paper);

    void insertEntry(ReprintAuthorEntry entry);

    List<User> getAuthorInfoByPaperId(String id);

    void updateEntryById(ReprintAuthorEntry entry);

    void deleteEntryByStatus(String status);

    void deleteEntryById(String id);

    List<User> getAllUsers();

    int deletePaperEntryById(String id);

    void deletePaperEntryByStatus(String status);

    int completePaperEntryById(String id);

    void completePaperEntryByStatus(String status);

    int rollBackToSuccessById(String id);

    List<ReprintAuthorEntry> getMatchEntryById(String id);

    void deleteEntryByPaperId(String paper);

    void updatePaperRPStatusById(String id);
}
