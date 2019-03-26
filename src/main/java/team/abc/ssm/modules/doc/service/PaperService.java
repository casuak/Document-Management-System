package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

import team.abc.ssm.modules.doc.dao.PaperDao;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

@Service
public class PaperService {

    @Resource
    private PaperDao paperDao;

    @Autowired
    private UserService userService;

    public int deleteByPrimaryKey(String id) {
        return paperDao.deleteByPrimaryKey(id);
    }

    public int insert(Paper record) {
        return paperDao.insert(record);
    }

    public int insertOrUpdate(Paper record) {
        return paperDao.insertOrUpdate(record);
    }

    public int insertOrUpdateSelective(Paper record) {
        return paperDao.insertOrUpdateSelective(record);
    }

    public int insertSelective(Paper record) {
        return paperDao.insertSelective(record);
    }

    public Paper selectByPrimaryKey(String id) {
        return paperDao.selectByPrimaryKey(id);
    }

    public int updateByPrimaryKeySelective(Paper record) {
        return paperDao.updateByPrimaryKeySelective(record);
    }

    public int updateByPrimaryKey(Paper record) {
        return paperDao.updateByPrimaryKey(record);
    }

    public int updateBatch(List<Paper> list) {
        return paperDao.updateBatch(list);
    }

    public int batchInsert(List<Paper> list) {
        return paperDao.batchInsert(list);
    }

    /**
     * 查询结果为空时返回一个空的arrayList
     */
    public List<Paper> selectListByPage(Paper paper) {
        List<Paper> ids = paperDao.selectIdsByPage(paper);
        if (ids.size() == 0) return new ArrayList<>();
        return paperDao.selectListByIds(ids);
    }

    public int selectSearchCount(Paper paper) {
        return paperDao.selectSearchCount(paper);
    }

    // update status = 0 where status is null
    // split first and second author name from authorList
    public boolean initAll() {
        Paper params = new Paper();
        params.setStatus("-1");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        for (Paper paper : paperList) {
            paper.setStatus("0");
            if (paper.getAuthorList() == null) {
                paper.setFirstAuthorName(null);
                paper.setSecondAuthorId(null);
                continue;
            }
            String firstAuthorName;
            String secondAuthorName;
            String[] authorList = paper.getAuthorList().split(";");
            if (authorList.length == 0) {
                firstAuthorName = null;
                secondAuthorName = null;
            } else if (authorList.length == 1) {
                firstAuthorName = authorList[0];
                secondAuthorName = null;
            } else {
                firstAuthorName = authorList[0];
                secondAuthorName = authorList[1];
            }
            paper.setFirstAuthorName(firstAuthorName);
            paper.setSecondAuthorName(secondAuthorName);
        }
        int count = paperDao.updateBatch(paperList);
        return count == paperList.size();
    }

    public boolean deleteListByIds(List<Paper> paperList) {
        int count = paperDao.deleteListByIds(paperList);
        return count == paperList.size();
    }

    // match user
    public boolean paperUserMatch() {
        Paper params = new Paper();
        params.setStatus("0");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        List<User> userList = userService.selectTeacherStudentList();
        for (Paper paper : paperList) {
            String firstAuthorName = paper.getFirstAuthorName();
            String secondAuthorName = paper.getSecondAuthorName();
            // TODO: match author name with userList and set authorId if match success
        }
        return true;
    }
}
