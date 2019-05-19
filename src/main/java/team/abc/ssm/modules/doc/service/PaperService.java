package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

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
//        List<Paper> ids = paperDao.selectIdsByPage(paper);
//        if (ids.size() == 0) return new ArrayList<>();
        return paperDao.selectListByIds(paper);
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
        List<User> _userList = userService.getAllUsers2();
        List<User> userList = new ArrayList<>();
        List<User> studentList = new ArrayList<>();
        List<User> teacherList = new ArrayList<>();
        // 过滤用户
        for (User user : _userList) {
            if ("teacher;student;".contains(user.getUserType()))
                userList.add(user);
            if ("teacher".equals(user.getUserType()))
                teacherList.add(user);
            if ("student".equals(user.getUserType()))
                studentList.add(user);
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
        for (Paper paper : paperList) {
            String firstAuthorName = ";";
            String secondAuthorName = ";";
            String authorList = ";";
            if (paper.getFirstAuthorName() != null)
                firstAuthorName = paper.getFirstAuthorName().toLowerCase() + ";";
            if (paper.getSecondAuthorName() != null)
                secondAuthorName = paper.getSecondAuthorName().toLowerCase() + ";";
            if (paper.getAuthorList() != null)
                authorList = paper.getAuthorList().toLowerCase() + ";";
            List<User> matchList1 = new ArrayList<>();
            List<User> matchList2 = new ArrayList<>();
            // 匹配第一作者
            for (User user : userList) {
                if (user.getNicknames().contains(firstAuthorName)) {
                    matchList1.add(user);
                }
            }
            // 无匹配
            if (matchList1.size() == 0) {
                paper.setStatus("1"); // 整体出错
                paper.setStatus1("2"); // 一作无匹配
                paper.setStatus2("2"); // 二作无匹配
                paper.setFirstAuthorId(null);
                paper.setSecondAuthorId(null);
            }
            // 唯一匹配
            else if (matchList1.size() == 1) {
                User firstAuthor = matchList1.get(0);
                // 第一作者唯一匹配老师
                if ("teacher".equals(firstAuthor.getUserType())) {
                    // 在学生中匹配第二作者
                    for (User student : studentList) {
                        if (student.getNicknames().contains(secondAuthorName)) {
                            // 过滤学生中导师不是第一作者的
                            if (student.getTutorWorkId() == null ||
                                    !student.getTutorWorkId().equals(firstAuthor.getWorkId()))
                                continue;
                            matchList2.add(student);
                        }
                    }
                    if (matchList2.size() == 0) {
                        paper.setStatus("2"); // 整体成功
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("2"); // 二作无匹配
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setSecondAuthorId(null);
                    } else if (matchList2.size() == 1) {
                        paper.setStatus("2"); // 整体成功
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("0"); // 二作成功
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setSecondAuthorId(matchList2.get(0).getWorkId());
                    } else {
                        paper.setStatus("1"); // 整体出错
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("1"); // 二作重名
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setSecondAuthorId(null);
                    }
                }
                // 第一作者唯一匹配学生
                else if ("student".equals(firstAuthor.getUserType())) {
                    User tutor = firstAuthor.getTutor();
                    if (tutor == null) {
                        paper.setStatus("2"); // 整体成功(学生信息中无导师)
                        paper.setStatus1("0"); // 一作成功
                        paper.setStatus2("2"); // 二作无匹配
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setSecondAuthorId(null);
                    } else {
                        String[] tutorNicknames = tutor.getNicknames().split(";");
                        // 验证学生导师在论文的作者列表中
                        boolean flag = false;
                        for (String nickname : tutorNicknames) {
                            if (authorList.contains(nickname)) {
                                flag = true;
                                break;
                            }
                        }
                        paper.setStatus("2"); // 整体成功
                        paper.setStatus1("0"); // 一作成功
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        if (flag) {
                            paper.setStatus2("0"); // 二作成功
                            paper.setSecondAuthorId(tutor.getWorkId());
                        } else {
                            paper.setStatus2("2"); // 二作无匹配
                            paper.setSecondAuthorId(null);
                        }
                    }
                }
            }
            // 重复匹配
            else {
                // 学院过滤
                String danwei = paper.getDanweiCN();
                List<User> _matchList1 = new ArrayList<>();
                if (danwei != null && !danwei.equals("")) {
                    for (User user : matchList1) {
                        if (user.getSchool().equals(danwei)) {
                            _matchList1.add(user);
                        }
                    }
                }
                matchList1 = _matchList1;
                // 统计老师和学生各自的数量
                int studentCount = 0;
                int teacherCount = 0;
                for (User user : matchList1) {
                    if ("student".equals(user.getUserType()))
                        studentCount += 1;
                    else
                        teacherCount += 1;
                }
                // 全是老师
                if (studentCount == 0) {
                    // 过滤后唯一
                    if (_matchList1.size() == 1) {
                        User firstAuthor = _matchList1.get(0);
                        // 在学生中匹配第二作者
                        for (User student : studentList) {
                            if (student.getNicknames().contains(secondAuthorName)) {
                                // 过滤学生中导师不是第一作者的
                                if (student.getTutorWorkId() == null ||
                                        !student.getTutorWorkId().equals(firstAuthor.getWorkId()))
                                    continue;
                                matchList2.add(student);
                            }
                        }
                        if (matchList2.size() == 0) {
                            paper.setStatus("2"); // 整体成功
                            paper.setStatus1("0"); // 一作成功
                            paper.setStatus2("2"); // 二作无匹配
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setSecondAuthorId(null);
                        } else if (matchList2.size() == 1) {
                            paper.setStatus("2"); // 整体成功
                            paper.setStatus1("0"); // 一作成功
                            paper.setStatus2("0"); // 二作成功
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setSecondAuthorId(matchList2.get(0).getWorkId());
                        } else {
                            paper.setStatus("1"); // 整体出错
                            paper.setStatus1("0"); // 一作成功
                            paper.setStatus2("1"); // 二作重名
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setSecondAuthorId(null);
                        }
                    }
                    // 过滤后无匹配或匹配数量大于1
                    else {
                        paper.setStatus("1"); // 整体出错
                        paper.setStatus1("2"); // 一作无匹配
                        paper.setStatus2("2"); // 二作无匹配
                        paper.setFirstAuthorId(null);
                        paper.setSecondAuthorId(null);
                    }
                }
                // 全是学生
                else if (teacherCount == 0) {
                    // 导师过滤
                    if (_matchList1.size() > 1) {
                        matchList1.clear();
                        matchList1.addAll(_matchList1);
                        _matchList1.clear();
                        for (User student : matchList1) {
                            boolean flag = false;
                            if (student.getTutor() == null) continue;
                            String[] nicknames = student.getTutor().getNicknames().split(";");
                            for (String nickname : nicknames) {
                                if (authorList.contains(nickname)) {
                                    flag = true;
                                    break;
                                }
                            }
                            if (flag)
                                _matchList1.add(student);
                        }
                    }
                    // 此时的情况一般是同一个学生，分为博士和硕士两个身份
                    if (_matchList1.size() == 2) {
                        User s1 = _matchList1.get(0); // 研究生
                        User s2 = _matchList1.get(1); // 博士
                        if (s1.getHireDate().after(s2.getHireDate())) {
                            User tmp = s1;
                            s1 = s2;
                            s2 = tmp;
                        }
                        boolean sameStudent = false;
                        try {
                            if (s1.getStudentTrainLevel().equals("硕士") && s2.getStudentTrainLevel().equals("博士")) {
                                if (s1.getRealName().equals(s2.getRealName())) {
                                    sameStudent = true;
                                    if (paper.getPublishDate().after(s2.getHireDate())) {
                                        _matchList1.remove(0);
                                    } else {
                                        _matchList1.remove(1);
                                    }
                                }
                            }
                        } catch (Exception ignored) {

                        }
                        if (sameStudent) {
                            User firstAuthor = _matchList1.get(0);
                            User tutor = firstAuthor.getTutor();
                            if (tutor == null) {
                                paper.setStatus("2"); // 整体成功(学生信息中无导师)
                                paper.setStatus1("0"); // 一作成功
                                paper.setStatus2("2"); // 二作无匹配
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setSecondAuthorId(null);
                            } else {
                                String[] tutorNicknames = tutor.getNicknames().split(";");
                                // 验证学生导师在论文的作者列表中
                                boolean flag = false;
                                for (String nickname : tutorNicknames) {
                                    if (authorList.contains(nickname)) {
                                        flag = true;
                                        break;
                                    }
                                }
                                paper.setStatus("2"); // 整体成功
                                paper.setStatus1("0"); // 一作成功
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                if (flag) {
                                    paper.setStatus2("0"); // 二作成功
                                    paper.setSecondAuthorId(tutor.getWorkId());
                                } else {
                                    paper.setStatus2("2"); // 二作无匹配
                                    paper.setSecondAuthorId(null);
                                }
                            }
                        } else {
                            paper.setStatus("1"); // 整体出错
                            paper.setStatus1("2"); // 一作无匹配
                            paper.setStatus2("2"); // 二作无匹配
                            paper.setFirstAuthorId(null);
                            paper.setSecondAuthorId(null);
                        }
                    }
                    // 过滤后唯一
                    else if (_matchList1.size() == 1) {
                        User firstAuthor = _matchList1.get(0);
                        User tutor = firstAuthor.getTutor();
                        if (tutor == null) {
                            paper.setStatus("2"); // 整体成功(学生信息中无导师)
                            paper.setStatus1("0"); // 一作成功
                            paper.setStatus2("2"); // 二作无匹配
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            paper.setSecondAuthorId(null);
                        } else {
                            String[] tutorNicknames = tutor.getNicknames().split(";");
                            // 验证学生导师在论文的作者列表中
                            boolean flag = false;
                            for (String nickname : tutorNicknames) {
                                if (authorList.contains(nickname)) {
                                    flag = true;
                                    break;
                                }
                            }
                            paper.setStatus("2"); // 整体成功
                            paper.setStatus1("0"); // 一作成功
                            paper.setFirstAuthorId(firstAuthor.getWorkId());
                            if (flag) {
                                paper.setStatus2("0"); // 二作成功
                                paper.setSecondAuthorId(tutor.getWorkId());
                            } else {
                                paper.setStatus2("2"); // 二作无匹配
                                paper.setSecondAuthorId(null);
                            }
                        }
                    }
                    // 过滤后无匹配或匹配数量大于1
                    else {
                        paper.setStatus("1"); // 整体出错
                        paper.setStatus1("2"); // 一作无匹配
                        paper.setStatus2("2"); // 二作无匹配
                        paper.setFirstAuthorId(null);
                        paper.setSecondAuthorId(null);
                    }
                }
                // 混合
                else {
                    // 按学院过滤
                    List<User> _matchlist1 = new ArrayList<>();
                    for (User user : matchList1) {
                        if (user.getSchool().equals(paper.getDanweiCN())) {

                        }
                    }
                    paper.setStatus("1"); // 整体出错
                    paper.setStatus1("2"); // 一作无匹配
                    paper.setStatus2("2"); // 二作无匹配
                    paper.setFirstAuthorId(null);
                    paper.setSecondAuthorId(null);
                }
            }
        }
        paperDao.updateBatch(paperList);
        return true;
    }

    public boolean paperUserMatch2() {
        // -----------------------------取值部分start----------------------------------
        Paper params = new Paper();
        params.setStatus("0");
        List<Paper> paperList = paperDao.selectListByStatus(params);
        List<User> _userList = userService.getAllUsers2();
        List<User> userList = new ArrayList<>();
        List<User> studentList = new ArrayList<>();
        List<User> teacherList = new ArrayList<>();
        // 过滤用户
        for (User user : _userList) {
            if ("teacher;student;".contains(user.getUserType()))
                userList.add(user);
            if ("teacher".equals(user.getUserType()))
                teacherList.add(user);
            if ("student".equals(user.getUserType()))
                studentList.add(user);
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
            if (paper.getFirstAuthorName() != null)
                firstAuthorName = paper.getFirstAuthorName().toLowerCase() + ";";
            if (paper.getSecondAuthorName() != null)
                secondAuthorName = paper.getSecondAuthorName().toLowerCase() + ";";
            if (paper.getAuthorList() != null)
                authorList = paper.getAuthorList().toLowerCase() + ";";
            // -----------------------论文数据预处理end-------------------------------
            // -----------------------正式匹配start-------------------------------
            List<User> matchList1 = new ArrayList<>(); // 第一作者匹配列表
            List<User> matchList2 = new ArrayList<>(); // 第二作者匹配列表
            for (User user : userList) { // 匹配一作
                boolean flag = true;
                if (flag && user.getRealName().equals("SULTAN MANZOOR") && paper.getPaperName().contains("Cost and energy analysis of a grid-tie solar")) {
                    int a = 1;
                }
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
                        paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                    } else {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
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
                    } else if (matchList2.size() == 1) {
                        paper.setStatus("2"); /***************************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                        paper.setSecondAuthorId(matchList2.get(0).getWorkId());
                    } else if (matchList2.size() == 2) {
                        User secondAuthor = getRightStudent(matchList2.get(0), matchList2.get(1), paper.getPublishDate());
                        if (secondAuthor == null) {
                            paper.setStatus("1");
                        } else {
                            if (testFirstAuthorAsTutor(secondAuthor.getTutorNicknames(), authorList)) {
                                paper.setStatus("2"); /***************************/
                                paper.setSecondAuthorId(secondAuthor.getWorkId());
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                            } else {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                            }
                        }
                    } else {
                        paper.setStatus("1"); /************二作不确定***************/
                        paper.setFirstAuthorId(firstAuthor.getWorkId());
                    }
                }
            } else { // 重复
                int studentCount = 0;
                int teacherCount = 0;
                for (User user : matchList1) {
                    if ("student".equals(user.getUserType()))
                        studentCount += 1;
                    else
                        teacherCount += 1;
                }
                if (teacherCount == 0) { // 全是学生
                    if (studentCount == 2) {
                        User firstAuthor = getRightStudent(matchList1.get(0), matchList1.get(1), paper.getPublishDate());
                        if (firstAuthor == null) {
                            paper.setStatus("1");
                        } else {
                            if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                                paper.setSecondAuthorId(firstAuthor.getTutorWorkId());
                            } else {
                                paper.setStatus("2"); /***************************/
                                paper.setFirstAuthorId(firstAuthor.getWorkId());
                            }
                        }
                    } else {
                        paper.setStatus("1");
                    }
                } else {
                    paper.setStatus("1");
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
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                        } else {
                            paper.setStatus("2"); /***************************/
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
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
                            paper.setStatus("2"); /***************************/
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                        } else if (matchList1.size() == 1) {
                            paper.setStatus("2"); /***************************/
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
                            paper.setFirstAuthorId(matchList1.get(0).getWorkId());
                        } else if (matchList1.size() == 2) {
                            User firstAuthor = getRightStudent(matchList1.get(0), matchList1.get(1), paper.getPublishDate());
                            if (firstAuthor == null) {
                                paper.setStatus("1");
                            } else {
                                if (testSecondAuthorAsTutor(firstAuthor.getTutorNicknames(), authorList)) {
                                    paper.setStatus("2"); /***************************/
                                    paper.setFirstAuthorId(firstAuthor.getWorkId());
                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                } else {
                                    paper.setStatus("2"); /***************************/
                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                }
                            }
                        } else {
                            paper.setStatus("1"); /************一作不确定***************/
                            paper.setSecondAuthorId(secondAuthor.getWorkId());
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
                        if (studentCount == 2) {
                            User secondAuthor = getRightStudent(matchList2.get(0), matchList2.get(1), paper.getPublishDate());
                            if (secondAuthor == null) {
                                paper.setStatus("1");
                            } else {
                                if (testFirstAuthorAsTutor(secondAuthor.getTutorNicknames(), authorList)) {
                                    paper.setStatus("2"); /***************************/
                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                    paper.setFirstAuthorId(secondAuthor.getTutorWorkId());
                                } else {
                                    paper.setStatus("2"); /***************************/
                                    paper.setSecondAuthorId(secondAuthor.getWorkId());
                                }
                            }
                        } else {
                            paper.setStatus("1");
                        }
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
        String authors = "";
        for (int i = 0; i < _authors.length; i++) {
            if (i == 1) continue;
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

    // 2学生同一人判断
    private User getRightStudent(User s1, User s2, Date publishDate) {
        // 首先判断两人是否为同一人
        if (!s1.getRealName().equals(s2.getRealName()))
            return null;
        if (s1.getHireDate().after(s2.getHireDate())) {
            User tmp = s1;
            s1 = s2;
            s2 = tmp;
        }
        if (s1.getStudentTrainLevel().equals("硕士") && s2.getStudentTrainLevel().equals("博士")) ;
        else return null;
        // 确定人
        if (publishDate.after(s2.getHireDate())) {
            return s2;
        } else {
            return s1;
        }
    }

    public boolean deleteByStatus(String status) {
        paperDao.deleteByStatus(status);
        return true;
    }

    public boolean selectAuthor(String paperId, int authorIndex, String authorWorkId) {
        paperDao.selectAuthor(paperId, authorIndex, authorWorkId);
        return true;
    }
}
