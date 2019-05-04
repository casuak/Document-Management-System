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
import team.abc.ssm.modules.doc.entity.DanweiNicknames;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

@Service
public class PaperService {

    @Resource
    private PaperDao paperDao;

    @Autowired
    private UserService userService;

    @Autowired
    private DanweiNicknamesService danweiNicknamesService;

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

    public boolean initAll() {
        Paper params = new Paper();
        params.setStatus("-1");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        List<DanweiNicknames> danweiList = danweiNicknamesService.selectAllList();
        for (DanweiNicknames danwei : danweiList) {
            List<String> nicknameList = new ArrayList<>();
            String nicknames = "";
            nicknameList.add(danwei.getNickname1());
            nicknameList.add(danwei.getNickname2());
            nicknameList.add(danwei.getNickname3());
            nicknameList.add(danwei.getNickname4());
            nicknameList.add(danwei.getNickname5());
            nicknameList.add(danwei.getNickname6());
            nicknameList.add(danwei.getNickname7());
            nicknameList.add(danwei.getNickname8());
            nicknameList.add(danwei.getNickname9());
            nicknameList.add(danwei.getNickname10());
            nicknameList.add(danwei.getNickname11());
            nicknameList.add(danwei.getNickname12());
            for (int i = nicknameList.size() - 1; i >= 0; i--) {
                if (nicknameList.get(i) == null || nicknameList.get(i).equals(""))
                    nicknameList.remove(i);
            }
            for (String nickname : nicknameList) {
                nicknames += nickname + ";";
            }
            String[] test = nicknames.split(";");
            danwei.setNicknameList(nicknameList);
            danwei.setNicknames(nicknames);
        }
        for (Paper paper : paperList) {
            // 更新状态信息为初始化成功
            paper.setStatus("0");
            // 1、从作者列表中提取第一、二作者
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
            // 2、将导入的PD（月/日）和PY（年）字段合并为单个出版日期
            if (paper.get_PY() != 0 && paper.get_PD() != null) {
                int year = paper.get_PY();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(paper.get_PD());
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);
                calendar.set(year, month, day);
                paper.setPublishDate(calendar.getTime());
            }
            // 3、过滤署名单位中不包含“Beijing Inst Technol”的论文
            if (paper.getDanwei() != null && !paper.getDanwei().contains("Beijing Inst Technol")) {
                paper.setStatus("-2");
            }
            // 4、提取署名单位中北京理工大学学院别名，并与单位别名表匹配，填充上中文单位名
            if (paper.getStatus().equals("0")) {
                String[] danweis = paper.getDanwei().split(",");
                boolean flag = false;
                for (String danwei : danweis) {
                    danwei = danwei.trim();
                    for (DanweiNicknames targetDanwei : danweiList) {
                        if (targetDanwei.getNicknames().contains(danwei)) {
                            paper.setDanweiCN(targetDanwei.getName());
                            flag = true;
                            break;
                        }
                    }
                    if (flag) break;
                }
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
            int first_matchCount = 0;
            int second_matchCount = 0;
            User first_lastMatch = null;
            User second_lastMatch = null;
            // 匹配第一作者
            for (User user : userList) {
                if (user.getNicknames().contains(firstAuthorName)) {
                    first_matchCount += 1;
                    first_lastMatch = user;
                }
            }
            if (first_matchCount == 0) {
                paper.setStatus("1"); // 整体出错
                paper.setStatus1("2"); // 一作无匹配
                paper.setStatus2("2"); // 二作无匹配
                paper.setFirstAuthorId(null);
                paper.setSecondAuthorId(null);
            } else if (first_matchCount == 1) {
                // 第一作者唯一匹配老师
                if ("teacher".contains(first_lastMatch.getUserType())) {
                    // 在学生中匹配第二作者
                    for (User user : userList) {
                        // 过滤老师
                        if (user.getUserType().equals("teacher")) continue;
                        if (user.getNicknames().contains(secondAuthorName)) {
                            // 过滤学生中导师不是第一作者的
                            if (!user.getTutor_work_id().equals(first_lastMatch.getWorkId()))
                                continue;
                            second_matchCount += 1;
                            second_lastMatch = user;
                        }
                    }
                    if (second_matchCount == 0) {
                        paper.setStatus("1"); // 整体成功
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("2"); // 二作无匹配
                        paper.setFirstAuthorId(first_lastMatch.getId());
                        paper.setSecondAuthorId(null);
                    } else if (second_matchCount == 1) {
                        paper.setStatus2("2"); // 整体成功
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("2"); // 二作成功
                        paper.setFirstAuthorId(first_lastMatch.getId());
                        paper.setSecondAuthorId(second_lastMatch.getId());
                    } else {
                        paper.setStatus2("2"); // 整体出错
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("1"); // 二作重名
                        paper.setFirstAuthorId(first_lastMatch.getId());
                        paper.setSecondAuthorId(null);
                    }
                } else {
                    // 第一作者唯一匹配学生
                    String tutorId = first_lastMatch.getTutor_work_id();
                }
            } else {

            }
        }
//        paperDao.updateBatch(paperList);
        return true;
    }

    public boolean deleteByStatus(String status) {
        paperDao.deleteByStatus(status);
        return true;
    }
}
