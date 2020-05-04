package team.abc.ssm.modules.document.paper.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

import team.abc.ssm.modules.document.authorStatistics.service.AuthorStatisticsService;
import team.abc.ssm.modules.document.journal.dao.JournalDao;
import team.abc.ssm.modules.document.paper.dao.PaperDao;
import team.abc.ssm.modules.sys.entity.DanweiNicknames;
import team.abc.ssm.modules.document.journal.entity.Journal;
import team.abc.ssm.modules.document.paper.entity.Paper;
import team.abc.ssm.modules.sys.service.DanweiNicknamesService;
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

    @Autowired
    private JournalDao journalDao;

    @Autowired
    private AuthorStatisticsService authorStatisticsService;

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
//        List<Paper> ids = paperDao.selectIdsByPage(paper);
//        if (ids.size() == 0) return new ArrayList<>();
        return paperDao.selectListByIds(paper);
    }

    public int selectSearchCount(Paper paper) {
        return paperDao.selectSearchCount(paper);
    }

    public boolean initAll() {
        List<Paper> allList = paperDao.selectAll();
        List<Paper> initList = new ArrayList<>();
        List<Journal> journalList = journalDao.listAll();
        for (Paper paper : allList) {
            if (paper.getStatus().equals("-1"))
                initList.add(paper);
        }
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

//        List<Paper> updateList = new ArrayList<>();
        for (Paper paper : initList) {
            // 更新状态信息为初始化成功
            paper.setStatus("0");
            // 0、筛选重复论文项（论文的入仓号不重复）
            int count = 0;
            for (Paper repeat : allList) {
                try {
                    if (repeat.getStoreNum().equals(paper.getStoreNum())) {
                        count++;
                    }
                } catch (NullPointerException e) {
                    // Who care
                }
                if (count > 1) break;
            }
            if (count > 1) {
                paper.setStatus("-2");
                continue;
            }
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
            if (paper.get_PY() != 0) {
                int year = paper.get_PY();
                Calendar calendar = Calendar.getInstance();
                if (paper.get_PD() != null)
                    calendar.setTime(paper.get_PD());
                else
                    calendar.setTime(new Date(0));
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
                if (paper.getDanwei() == null || paper.getDanwei().equals("")) {

                } else {
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
            // 5、添加所属期刊信息
            for (Journal journal : journalList) {
                if (journal.getIssn().equals(paper.getISSN())) {
                    paper.setImpactFactor(journal.getImpactFactor());
                    paper.setJournalDivision(journal.getJournalDivision());
                    break;
                }
            }
        }
        if (initList.size() == 0) return true;
        int count = paperDao.updateBatch(initList);
        return count == initList.size();
    }

    public boolean deleteListByIds(List<Paper> paperList) {
        paperList = paperDao.selectDeleteListByIds(paperList);
        List<Paper> finishList = new ArrayList<>();
        for (Paper paper : paperList) {
            if ("3".equals(paper.getStatus())) {
                finishList.add(paper);
            }
        }
        if (finishList.size() > 0)
            authorStatisticsService.deletePaperCount(finishList);

        int count = paperDao.deleteListByIds(paperList);
        return count == paperList.size();
    }

    public boolean convertToSuccessByIds(List<Paper> paperList) {
        int count = paperDao.convertToSuccessByIds(paperList);
        return count == paperList.size();
    }

    public void completeAll() {
        Paper paper = new Paper();
        paper.setStatus("2");
        List<Paper> result = paperDao.selectListByStatus(paper);
        List<Paper> revertList = authorStatisticsService.addPaperCount(result);
        paperDao.completeAll();

        if(revertList != null && revertList.size()>0)
            paperDao.convertToSuccessByIds(revertList);


    }

    private void setPaperDanweiCn(Paper paper, User user) {
        if (paper.getDanweiCN() == null || paper.getDanweiCN().equals("")) {
            paper.setDanweiCN(user.getSchool());
        }
    }

    // match user
    public boolean paperUserMatch() {
        // -----------------------------取值部分start----------------------------------
        Paper params = new Paper();
        params.setStatus("0");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        List<User> allList = userService.getAllUsers2();
        List<User> userList = new ArrayList<>();
        List<User> studentList = new ArrayList<>();
        List<User> teacherList = new ArrayList<>();
        // 初始化三个列表
        for (User user : allList) {
            if (user == null) continue;
            if (user.getUserType() == null) continue;
            if (user.getWorkId() == null) continue;
            if ("teacher".equals(user.getUserType())) {
                // 目前老师数据存在重复，所以需要去重
                boolean repeat = false;
                for (User teacher : teacherList) {
                    if (teacher.getWorkId().equals(user.getWorkId())) {
                        repeat = true;
                        break;
                    }
                }
                if (!repeat) {
                    teacherList.add(user);
                    userList.add(user);
                }
            }
            if ("student".equals(user.getUserType())) {
                studentList.add(user);
                userList.add(user);
            }
        }
        // 学生导师赋值
        for (User student : studentList) {
            String tutorWorkId = student.getTutorWorkId();
            if (tutorWorkId != null) {
                for (User teacher : teacherList) {
                    if (tutorWorkId.equals(teacher.getWorkId())) {
                        student.setTutor(teacher);
                        break;
                    }
                }
            }
        }
        // -----------------------------取值部分end----------------------------------
        // -----------------------------匹配部分start----------------------------------
        for (Paper paper : paperList) {
            // -----------------------论文数据预处理start-------------------------------
            String firstAuthorName = ";";
            String secondAuthorName = ";";
            String authorList = ";";
            String[] authors = new String[0];
            if (paper.getFirstAuthorName() == null || paper.getFirstAuthorName().equals("")) {
                paper.setStatus("1");
                continue;
            }
            firstAuthorName = paper.getFirstAuthorName().toLowerCase() + ";";
            if (paper.getSecondAuthorName() != null)
                secondAuthorName = paper.getSecondAuthorName().toLowerCase() + ";";
            if (paper.getAuthorList() != null) {
                authorList = paper.getAuthorList().toLowerCase() + ";";
                authors = authorList.split(";");
                for (int i = 0; i < authors.length; i++) {
                    authors[i] = authors[i].trim();
                }
            }
            // -----------------------论文数据预处理end-------------------------------
            // -----------------------正式匹配start-------------------------------
            List<User> matchList1 = new ArrayList<>(); // 第一作者匹配列表
            List<User> matchList2 = new ArrayList<>(); // 第二作者匹配列表
            for (User user : userList) { // 匹配一作
                boolean flag = true;
                if (paper.getDanweiCN() != null && !paper.getDanweiCN().equals("")) // 学院一致
                    if (!paper.getDanweiCN().equals(user.getSchool()))
                        flag = false;
                if (flag && !user.getNicknames().contains(firstAuthorName)) // 别名匹配
                    flag = false;
                if (flag) matchList1.add(user);
            }
            if (matchList1.size() == 0) { // 无匹配
                paper.setStatus("1"); /***************************/
            } else if (matchList1.size() == 1) { // 唯一
                User firstAuthor = matchList1.get(0);
                if ("student".equals(firstAuthor.getUserType())) {
                    if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("student");
                        paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                        paper.setSecondAuthorCname(firstAuthor.getTutorName());
                        paper.setSecondAuthorType("teacher");
                        setPaperDanweiCn(paper, firstAuthor);

                    } else {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("student");
                        setPaperDanweiCn(paper, firstAuthor);
                    }
                } else if ("teacher".equals(firstAuthor.getUserType())) {
                    for (User student : studentList) { // 在学生中匹配二作
                        boolean flag = true;
                        if (paper.getDanweiCN() != null && !paper.getDanweiCN().equals("")) // 学院一致
                            if (!paper.getDanweiCN().equals(student.getSchool()))
                                flag = false;
                        if (flag && !student.getNicknames().contains(secondAuthorName)) // 别名匹配
                            flag = false;
                        if (flag && !student.getTutorWorkId().equals(firstAuthor.getWorkId())) // 导师匹配
                            flag = false;
                        if (flag) matchList2.add(student);
                    }
                    if (matchList2.size() == 0) { // 学生无匹配
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("teacher");
                        setPaperDanweiCn(paper, firstAuthor);
                    } else if (matchList2.size() == 1) {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("teacher");
                        paper.setSecondAuthorId(matchList2.get(0).getWorkId());
                        paper.setSecondAuthorCname(matchList2.get(0).getRealName());
                        paper.setSecondAuthorType("student");
                        setPaperDanweiCn(paper, firstAuthor);
                    } else if (matchList2.size() == 2) {
                        User secondAuthor = getRightStudent(matchList2.get(0), matchList2.get(1), paper.getPublishDate());
                        if (secondAuthor == null) {
                            paper.setStatus("1");
                        } else {
                            if (testFirstAuthorAsTutor(secondAuthor.getTutorNicknames(), authorList)) {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setFirstAuthorCname(firstAuthor.getRealName());
                                paper.setFirstAuthorType("teacher");
                                paper.setSecondAuthorId(secondAuthor.getWorkId());
                                paper.setSecondAuthorCname(secondAuthor.getRealName());
                                paper.setSecondAuthorType("student");
                                setPaperDanweiCn(paper, firstAuthor);
                            } else {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setFirstAuthorCname(firstAuthor.getRealName());
                                paper.setFirstAuthorType("teacher");
                                setPaperDanweiCn(paper, firstAuthor);
                            }
                        }
                    } else {
                        paper.setStatus("1"); /************二作不确定***************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("teacher");
                        setPaperDanweiCn(paper, firstAuthor);
                    }
                }
            } else { // 重复
                // 直接去除其中的老师，然后看学生的导师是否能和论文的其余作者匹配上
                List<User> studentList2 = new ArrayList<>();
                for (User user : matchList1) {
                    if (user.getUserType().equals("student")) {
                        studentList2.add(user);
                    }
                }
                User firstAuthor = null;
                if (studentList2.size() == 0) {
                    paper.setStatus("1");
                } else if (studentList2.size() == 2) {
                    firstAuthor = getRightStudent(matchList1.get(0), matchList1.get(1), paper.getPublishDate());
                    if (firstAuthor != null) {
                        if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                            paper.setStatus("2"); /***************************/
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setFirstAuthorCname(firstAuthor.getRealName());
                            paper.setFirstAuthorType("student");
                            paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                            paper.setSecondAuthorCname(firstAuthor.getTutorName());
                            paper.setSecondAuthorType("teacher");
                            setPaperDanweiCn(paper, firstAuthor);
                        } else {
                            paper.setStatus("2"); /***************************/
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setFirstAuthorCname(firstAuthor.getRealName());
                            paper.setFirstAuthorType("student");
                            setPaperDanweiCn(paper, firstAuthor);
                        }
                    }
                }
                // 重复学生数量大于1，且不满足前面的情况，通过学生导师缩小范围
                if (studentList2.size() > 0 && firstAuthor == null) {
                    List<User> matchList3 = new ArrayList<>();
                    for (User student : studentList2) {
                        String tutorNicknames = student.getTutorNicknames();
                        if (tutorNicknames == null || tutorNicknames.equals("")) continue;
                        for (int k = 0; k < authors.length; k++) {
                            if (k == 0) continue;
                            if (tutorNicknames.contains(authors[k])) {
                                matchList3.add(student);
                                firstAuthor = student;
                                break;
                            }
                        }
                    }
                    if (matchList3.size() == 0) {
                        paper.setStatus("1");
                    }
                    if (matchList3.size() == 1) {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setFirstAuthorCname(firstAuthor.getRealName());
                        paper.setFirstAuthorType("student");
                        paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                        paper.setSecondAuthorCname(firstAuthor.getTutorName());
                        paper.setSecondAuthorType("teacher");
                        setPaperDanweiCn(paper, firstAuthor);
                    } else if (matchList3.size() == 2) {
                        firstAuthor = getRightStudent(matchList3.get(0), matchList3.get(1), paper.getPublishDate());
                        if (firstAuthor != null) {
                            if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setFirstAuthorCname(firstAuthor.getRealName());
                                paper.setFirstAuthorType("student");
                                paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                                paper.setSecondAuthorCname(firstAuthor.getTutorName());
                                paper.setSecondAuthorType("teacher");
                                setPaperDanweiCn(paper, firstAuthor);
                            } else {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setFirstAuthorCname(firstAuthor.getRealName());
                                paper.setFirstAuthorType("student");
                                setPaperDanweiCn(paper, firstAuthor);
                            }
                        } else {
                            paper.setStatus("1");
                        }
                    } else {
                        paper.setStatus("1");
                    }
                }
            }
            // -----------------------正式匹配end-------------------------------
            //--------------*********优化匹配错误的情况start**********-------------------
            if (paper.getFirstAuthorId() == null && paper.getSecondAuthorId() == null) {
                matchList1.clear();
                matchList2.clear();
                for (User user : userList) { // 匹配二作
                    boolean flag = true;
                    if (paper.getDanweiCN() != null && !paper.getDanweiCN().equals("")) // 学院一致
                        if (!paper.getDanweiCN().equals(user.getSchool()))
                            flag = false;
                    if (flag && !user.getNicknames().contains(secondAuthorName)) // 别名匹配
                        flag = false;
                    if (flag) matchList2.add(user);
                }
                if (matchList2.size() == 0) ;
                else if (matchList2.size() == 1) {
                    User secondAuthor = matchList2.get(0);
                    if ("student".equals(secondAuthor.getUserType())) {
                        if (testFirstAuthorAsTutor(secondAuthor.getTutorNicknames(), authorList)) {
                            paper.setStatus("2"); /***************************/
                            paper.setFirstAuthorId(secondAuthor.getTutorWorkId());
                            paper.setFirstAuthorCname(secondAuthor.getTutorName());
                            paper.setFirstAuthorType("teacher");
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                            paper.setSecondAuthorCname(secondAuthor.getRealName());
                            paper.setSecondAuthorType("student");
                            setPaperDanweiCn(paper, secondAuthor);
                        } else {
                            paper.setStatus("1"); /***************************/
//                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                        }
                    } else if ("teacher".equals(secondAuthor.getUserType())) {
                        for (User student : studentList) { // 在学生中匹配一作
                            boolean flag = true;
                            if (paper.getDanweiCN() != null && !paper.getDanweiCN().equals("")) // 学院一致
                                if (!paper.getDanweiCN().equals(student.getSchool()))
                                    flag = false;
                            if (flag && !student.getNicknames().contains(firstAuthorName)) // 别名匹配
                                flag = false;
                            if (student.getTutorWorkId() == null ||
                                    !student.getTutorWorkId().equals(secondAuthor.getWorkId())) // 导师匹配
                                flag = false;
                            if (flag) matchList1.add(student);
                        }
                        if (matchList1.size() == 0) { // 学生无匹配
                            paper.setStatus("1"); /***************************/
//                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                        } else if (matchList1.size() == 1) {
                            paper.setStatus("2"); /***************************/
                            paper.setFirstAuthorId(matchList1.get(0).getWorkId());
                            paper.setFirstAuthorCname(matchList1.get(0).getRealName());
                            paper.setFirstAuthorType("student");
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                            paper.setSecondAuthorCname(secondAuthor.getRealName());
                            paper.setSecondAuthorType("teacher");
                            setPaperDanweiCn(paper, secondAuthor);
                        } else if (matchList1.size() == 2) {
                            User firstAuthor = getRightStudent(matchList1.get(0), matchList1.get(1), paper.getPublishDate());
                            if (firstAuthor == null) {
                                paper.setStatus("1");
                            } else {
                                if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                                    paper.setStatus("2"); /***************************/
                                    paper.setFirstAuthorId(firstAuthor.getWorkId());
                                    paper.setFirstAuthorCname(firstAuthor.getRealName());
                                    paper.setFirstAuthorType("student");
                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                    paper.setSecondAuthorCname(secondAuthor.getRealName());
                                    paper.setSecondAuthorType("teacher");
                                    setPaperDanweiCn(paper, secondAuthor);
                                } else {
                                    paper.setStatus("1"); /***************************/
//                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                }
                            }
                        } else {
                            paper.setStatus("1"); /************一作不确定***************/
//                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                        }
                    }
                } else { // 重复
                    int studentCount = 0;
                    int teacherCount = 0;
                    for (User user : matchList2) {
                        if ("student".equals(user.getUserType()))
                            studentCount += 1;
                        else
                            teacherCount += 1;
                    }
                    if (teacherCount == 0) { // 全是学生
                        paper.setStatus("1");
                    } else {
                        paper.setStatus("1");
                    }
                }
            }
            //---------------------------优化匹配错误的情况end------------------------------
        }
        // -----------------------------匹配部分end----------------------------------
        paperDao.updateBatch(paperList);
        return true;
    }

    // 当第一作者为学生时，获取第二作者老师的方法
    private boolean testSecondAuthorAsTutor(String nicknames, String authorList) {
        String[] _authors = authorList.split(";");
        String authors = "";
        for (int i = 1; i < _authors.length; i++) {
            authors += _authors[i].trim() + ";";
        }
        String[] tutorNicknames = nicknames.split(";");
        for (String nickname : tutorNicknames) {
            if (authors.contains(nickname)) {
                return true;
            }
        }
        return false;
    }

    private boolean testFirstAuthorAsTutor(String nicknames, String authorList) {
        String[] _authors = authorList.split(";");
        String authors = _authors[0] + ";";
//        for (int i = 0; i < _authors.length; i++) {
//            if (i == 1) continue;
//            authors += _authors[i].trim() + ";";
//        }
        String[] tutorNicknames = nicknames.split(";");
        for (String nickname : tutorNicknames) {
            if (authors.contains(nickname)) {
                return true;
            }
        }
        return false;
    }

    // 2学生同一人判断
    private User getRightStudent(User s1, User s2, Date publishDate) {
        // 首先判断两人是否为同一人
        if (!s1.getRealName().equals(s2.getRealName())) // 真名是否相同
            return null;
        if (s1.getHireDate() == null || s2.getHireDate() == null) return null;
        if (s1.getHireDate().after(s2.getHireDate())) {
            User tmp = s1;
            s1 = s2;
            s2 = tmp;
        }
        if (s1.getStudentTrainLevel().equals("硕士") && s2.getStudentTrainLevel().equals("博士")) ;
        else return null;
        // 确定人
        // 当论文日期不为空时，如果论文的发表晚于博士的入职时间，则归为博士，早于，则归于硕士
        // 论文日期为空时，判断不了
        if (publishDate == null) return null;
        if (publishDate.after(s2.getHireDate())) {
            return s2;
        } else {
            return s1;
        }
    }

    public boolean deleteByStatus(String status) {
        if ("3".equals(status)) {
            List<Paper> papers = paperDao.selectByStatus(status);
            authorStatisticsService.deletePaperCount(papers);
        }
        paperDao.deleteByStatus(status);
        return true;
    }

    public boolean selectAuthor(String paperId, int authorIndex, String authorWorkId) {
        paperDao.selectAuthor(paperId, authorIndex, authorWorkId);
        return true;
    }

    public boolean completeImportPaper() {
        List<Paper> importFromExcel = paperDao.selectPaperListByStatus("4");
        List<Paper> finished = paperDao.selectPaperListByStatus("3");
        List<Paper> toDelete = new ArrayList<>();
        boolean needFilter = true;

        if (importFromExcel == null || importFromExcel.size() == 0)
            return false;

        if (finished == null || finished.size() == 0)
            needFilter = false;

        for (Paper p : importFromExcel) {
            if (needFilter) {
                String storeNumber = p.getStoreNum();
                for (Paper f : finished) {
                    if (f.getStoreNum().equals(storeNumber)) {
                        toDelete.add(f);
                    }
                }
            }

            if (p.getFirstAuthorType() != null) {
                String type = p.getFirstAuthorType().equals("学生") ? "student" : "teacher";
                p.setFirstAuthorType(type);
            }
            if (p.getSecondAuthorType() != null) {
                String type = p.getSecondAuthorType().equals("学生") ? "student" : "teacher";
                p.setSecondAuthorType(type);
            }

            String first = p.getFirstAuthorId() == null ? "2" : "0";
            String second = p.getSecondAuthorId() == null ? "2" : "0";
            p.setStatus1(first);
            p.setStatus2(second);

            String ISSN = p.getISSN();
            p.setImpactFactor(journalDao.getImpactFactor(ISSN));//todo 数据库重复ISSN？
            p.setJournalDivision(journalDao.getDivision(ISSN));

            p.setStatus("3");
        }

        if (toDelete.size() > 0){
            paperDao.deleteListByIds(toDelete);
        }
        paperDao.updateBatch(importFromExcel);

        authorStatisticsService.addPaperCount(importFromExcel);

        return true;
    }
}
