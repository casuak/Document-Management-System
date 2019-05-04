package team.abc.ssm.modules.doc.service;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import team.abc.ssm.common.utils.SpringContextHolder;
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

    // 1. update status = '0' where status = '-1'
    // 2. split first and second author name from authorList
    // 3. set publishDate according _PY(year) and _PD(month, day)
    // 4. update status = '-2' where danwei doesn't contain 'Beijing Inst Technol'
    public boolean initAll() {
        Paper params = new Paper();
        params.setStatus("-1");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        for (Paper paper : paperList) {
            // 1. update status = 0 where status = '-1'
            paper.setStatus("0");
            // 2. split first and second author name from authorList
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
                firstAuthorName = authorList[0].trim();
                secondAuthorName = null;
            } else {
                firstAuthorName = authorList[0].trim();
                secondAuthorName = authorList[1].trim();
            }
            paper.setFirstAuthorName(firstAuthorName);
            paper.setSecondAuthorName(secondAuthorName);
            // 3. set publishDate according _PY(year) and _PD(month, day)
            if (paper.get_PY() != 0 && paper.get_PD() != null) {
                int year = paper.get_PY();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(paper.get_PD());
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);
                calendar.set(year, month, day);
                paper.setPublishDate(calendar.getTime());
            }
            // 4. update status = '-2' where danwei doesn't contain 'Beijing Inst Technol'
            if (paper.getDanwei() != null && !paper.getDanwei().contains("Beijing Inst Technol")) {
                paper.setStatus("-2");
            }
        }
        if (paperList.size() == 0) return true;
        int count = paperDao.updateBatch(paperList);
        return count == paperList.size();
    }

    public boolean deleteListByIds(List<Paper> paperList) {
        int count = paperDao.deleteListByIds(paperList);
        return count == paperList.size();
    }

    public boolean convertToSuccessByIds(List<Paper> paperList) {
        int count = paperDao.convertToSuccessByIds(paperList);
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
            // first one
            User lastMatchUser = null;
            int count = 0;
            for (User user : userList) {
                String nicknames = user.getNicknames();
                if (nicknames == null || nicknames.equals("")) continue;
                if (nicknames.contains(firstAuthorName)) {
                    count += 1;
                    lastMatchUser = user;
                }
            }
            if (lastMatchUser == null)
                paper.setStatus1("2"); // 无匹配
            else if (count == 1) {
                paper.setStatus1("0"); // 唯一匹配
                paper.setFirstAuthorId(lastMatchUser.getId());
            } else
                paper.setStatus1("1"); // 重名
            // second one
            lastMatchUser = null;
            count = 0;
            for (User user : userList) {
                String nicknames = user.getNicknames();
                try {
                    if (nicknames.contains(secondAuthorName)) {
                        count += 1;
                        lastMatchUser = user;
                    }
                } catch (NullPointerException e) {
                    //
                }
            }
            if (lastMatchUser == null)
                paper.setStatus2("2"); // 无匹配
            else if (count == 1) {
                paper.setStatus2("0"); // 唯一匹配
                paper.setSecondAuthorId(lastMatchUser.getId());
            } else
                paper.setStatus2("1"); // 重名
            // set paper match status
            if (paper.getStatus1().equals("0") && paper.getStatus2().equals("0")) {
                paper.setStatus("2"); // 成功
            } else {
                paper.setStatus("1"); // 出错
            }
            // 优化处理
            // 第一作者成功匹配老师
            // 第二作者
        }
        paperDao.updateBatch(paperList);
        return true;
    }

    public boolean deleteByStatus(String status) {
        paperDao.deleteByStatus(status);
        return true;
    }
}
