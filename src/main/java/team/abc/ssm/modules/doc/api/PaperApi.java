package team.abc.ssm.modules.doc.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.service.PaperService;

import java.util.List;

/**
 * selectIdList2     page + searchKey + status
 * initAll              init all paper whose status is null
 */
@Controller
@RequestMapping("api/doc/paper")
public class PaperApi extends BaseApi {

    @Autowired
    private PaperService paperService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody Paper paper) {
        Page<Paper> data = new Page<>();
        data.setResultList(paperService.selectListByPage(paper));
        data.setTotal(paperService.selectSearchCount(paper));
        return retMsg.Set(MsgType.SUCCESS, data);
    }

    /**
     * step1
     */
    @RequestMapping(value = "initAll", method = RequestMethod.POST)
    @ResponseBody
    public Object initAll() {
        paperService.initAll();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Paper> paperList) {
        paperService.deleteListByIds(paperList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    // set status = '2' where id in idList
    @RequestMapping(value = "convertToSuccessByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object convertToSuccessByIds(@RequestBody List<Paper> paperList) {
        paperService.convertToSuccessByIds(paperList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * step2
     */
    @RequestMapping(value = "paperUserMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object paperUserMatch() {
        try {
            paperService.paperUserMatch2();
        } catch (Exception e){
            e.printStackTrace();
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

//    public boolean paperUserMatch() {
//        Paper params = new Paper();
//        params.setStatus("0");
//        List<Paper> paperList = paperDao.selectListByStatus(params);
//        List<User> _userList = userService.getAllUsers2();
//        List<User> userList = new ArrayList<>();
//        List<User> studentList = new ArrayList<>();
//        List<User> teacherList = new ArrayList<>();
//        // 过滤用户
//        for (User user : _userList) {
//            if ("teacher;student;".contains(user.getUserType()))
//                userList.add(user);
//            if ("teacher".equals(user.getUserType()))
//                teacherList.add(user);
//            if ("student".equals(user.getUserType()))
//                studentList.add(user);
//        }
//        // 学生导师赋值
//        for (User student : studentList) {
//            String tutorWorkId = student.getTutorWorkId();
//            if (tutorWorkId != null) {
//                for (User teacher : teacherList) {
//                    if (tutorWorkId.equals(teacher.getWorkId())) {
//                        student.setTutor(teacher);
//                        break;
//                    }
//                }
//            }
//        }
//        for (Paper paper : paperList) {
//            String firstAuthorName = ";";
//            String secondAuthorName = ";";
//            String authorList = ";";
//            if (paper.getFirstAuthorName() != null)
//                firstAuthorName = paper.getFirstAuthorName().toLowerCase() + ";";
//            if (paper.getSecondAuthorName() != null)
//                secondAuthorName = paper.getSecondAuthorName().toLowerCase() + ";";
//            if (paper.getAuthorList() != null)
//                authorList = paper.getAuthorList().toLowerCase() + ";";
//            List<User> matchList1 = new ArrayList<>();
//            List<User> matchList2 = new ArrayList<>();
//            // 匹配第一作者
//            for (User user : userList) {
//                if (user.getNicknames().contains(firstAuthorName)) {
//                    matchList1.add(user);
//                }
//            }
//            // 无匹配
//            if (matchList1.size() == 0) {
//                paper.setStatus("1"); // 整体出错
//                paper.setStatus1("2"); // 一作无匹配
//                paper.setStatus2("2"); // 二作无匹配
//                paper.setFirstAuthorId(null);
//                paper.setSecondAuthorId(null);
//            }
//            // 唯一匹配
//            else if (matchList1.size() == 1) {
//                User firstAuthor = matchList1.get(0);
//                // 第一作者唯一匹配老师
//                if ("teacher".equals(firstAuthor.getUserType())) {
//                    // 在学生中匹配第二作者
//                    for (User student : studentList) {
//                        if (student.getNicknames().contains(secondAuthorName)) {
//                            // 过滤学生中导师不是第一作者的
//                            if (student.getTutorWorkId() == null ||
//                                    !student.getTutorWorkId().equals(firstAuthor.getWorkId()))
//                                continue;
//                            matchList2.add(student);
//                        }
//                    }
//                    if (matchList2.size() == 0) {
//                        paper.setStatus("2"); // 整体成功
//                        paper.setStatus1("0"); // 一作成功
//                        paper.setStatus2("2"); // 二作无匹配
//                        paper.setFirstAuthorId(firstAuthor.getWorkId());
//                        paper.setSecondAuthorId(null);
//                    } else if (matchList2.size() == 1) {
//                        paper.setStatus("2"); // 整体成功
//                        paper.setStatus1("0"); // 一作成功
//                        paper.setStatus2("0"); // 二作成功
//                        paper.setFirstAuthorId(firstAuthor.getWorkId());
//                        paper.setSecondAuthorId(matchList2.get(0).getWorkId());
//                    } else {
//                        paper.setStatus("1"); // 整体出错
//                        paper.setStatus1("0"); // 一作成功
//                        paper.setStatus2("1"); // 二作重名
//                        paper.setFirstAuthorId(firstAuthor.getWorkId());
//                        paper.setSecondAuthorId(null);
//                    }
//                }
//                // 第一作者唯一匹配学生
//                else if ("student".equals(firstAuthor.getUserType())) {
//                    User tutor = firstAuthor.getTutor();
//                    if (tutor == null) {
//                        paper.setStatus("2"); // 整体成功(学生信息中无导师)
//                        paper.setStatus1("0"); // 一作成功
//                        paper.setStatus2("2"); // 二作无匹配
//                        paper.setFirstAuthorId(firstAuthor.getWorkId());
//                        paper.setSecondAuthorId(null);
//                    } else {
//                        String[] tutorNicknames = tutor.getNicknames().split(";");
//                        // 验证学生导师在论文的作者列表中
//                        boolean flag = false;
//                        for (String nickname : tutorNicknames) {
//                            if (authorList.contains(nickname)) {
//                                flag = true;
//                                break;
//                            }
//                        }
//                        paper.setStatus("2"); // 整体成功
//                        paper.setStatus1("0"); // 一作成功
//                        paper.setFirstAuthorId(firstAuthor.getWorkId());
//                        if (flag) {
//                            paper.setStatus2("0"); // 二作成功
//                            paper.setSecondAuthorId(tutor.getWorkId());
//                        } else {
//                            paper.setStatus2("2"); // 二作无匹配
//                            paper.setSecondAuthorId(null);
//                        }
//                    }
//                }
//            }
//            // 重复匹配
//            else {
//                // 学院过滤
//                String danwei = paper.getDanweiCN();
//                List<User> _matchList1 = new ArrayList<>();
//                if (danwei != null && !danwei.equals("")) {
//                    for (User user : matchList1) {
//                        if (user.getSchool().equals(danwei)) {
//                            _matchList1.add(user);
//                        }
//                    }
//                }
//                matchList1 = _matchList1;
//                // 统计老师和学生各自的数量
//                int studentCount = 0;
//                int teacherCount = 0;
//                for (User user : matchList1) {
//                    if ("student".equals(user.getUserType()))
//                        studentCount += 1;
//                    else
//                        teacherCount += 1;
//                }
//                // 全是老师
//                if (studentCount == 0) {
//                    // 过滤后唯一
//                    if (_matchList1.size() == 1) {
//                        User firstAuthor = _matchList1.get(0);
//                        // 在学生中匹配第二作者
//                        for (User student : studentList) {
//                            if (student.getNicknames().contains(secondAuthorName)) {
//                                // 过滤学生中导师不是第一作者的
//                                if (student.getTutorWorkId() == null ||
//                                        !student.getTutorWorkId().equals(firstAuthor.getWorkId()))
//                                    continue;
//                                matchList2.add(student);
//                            }
//                        }
//                        if (matchList2.size() == 0) {
//                            paper.setStatus("2"); // 整体成功
//                            paper.setStatus1("0"); // 一作成功
//                            paper.setStatus2("2"); // 二作无匹配
//                            paper.setFirstAuthorId(firstAuthor.getWorkId());
//                            paper.setSecondAuthorId(null);
//                        } else if (matchList2.size() == 1) {
//                            paper.setStatus("2"); // 整体成功
//                            paper.setStatus1("0"); // 一作成功
//                            paper.setStatus2("0"); // 二作成功
//                            paper.setFirstAuthorId(firstAuthor.getWorkId());
//                            paper.setSecondAuthorId(matchList2.get(0).getWorkId());
//                        } else {
//                            paper.setStatus("1"); // 整体出错
//                            paper.setStatus1("0"); // 一作成功
//                            paper.setStatus2("1"); // 二作重名
//                            paper.setFirstAuthorId(firstAuthor.getWorkId());
//                            paper.setSecondAuthorId(null);
//                        }
//                    }
//                    // 过滤后无匹配或匹配数量大于1
//                    else {
//                        paper.setStatus("1"); // 整体出错
//                        paper.setStatus1("2"); // 一作无匹配
//                        paper.setStatus2("2"); // 二作无匹配
//                        paper.setFirstAuthorId(null);
//                        paper.setSecondAuthorId(null);
//                    }
//                }
//                // 全是学生
//                else if (teacherCount == 0) {
//                    // 导师过滤
//                    if (_matchList1.size() > 1) {
//                        matchList1.clear();
//                        matchList1.addAll(_matchList1);
//                        _matchList1.clear();
//                        for (User student : matchList1) {
//                            boolean flag = false;
//                            if (student.getTutor() == null) continue;
//                            String[] nicknames = student.getTutor().getNicknames().split(";");
//                            for (String nickname : nicknames) {
//                                if (authorList.contains(nickname)) {
//                                    flag = true;
//                                    break;
//                                }
//                            }
//                            if (flag)
//                                _matchList1.add(student);
//                        }
//                    }
//                    // 此时的情况一般是同一个学生，分为博士和硕士两个身份
//                    if (_matchList1.size() == 2) {
//                        User s1 = _matchList1.get(0); // 研究生
//                        User s2 = _matchList1.get(1); // 博士
//                        if (s1.getHireDate().after(s2.getHireDate())) {
//                            User tmp = s1;
//                            s1 = s2;
//                            s2 = tmp;
//                        }
//                        boolean sameStudent = false;
//                        try {
//                            if (s1.getStudentTrainLevel().equals("硕士") && s2.getStudentTrainLevel().equals("博士")) {
//                                if (s1.getRealName().equals(s2.getRealName())) {
//                                    sameStudent = true;
//                                    if (paper.getPublishDate().after(s2.getHireDate())) {
//                                        _matchList1.remove(0);
//                                    } else {
//                                        _matchList1.remove(1);
//                                    }
//                                }
//                            }
//                        } catch (Exception ignored) {
//
//                        }
//                        if (sameStudent) {
//                            User firstAuthor = _matchList1.get(0);
//                            User tutor = firstAuthor.getTutor();
//                            if (tutor == null) {
//                                paper.setStatus("2"); // 整体成功(学生信息中无导师)
//                                paper.setStatus1("0"); // 一作成功
//                                paper.setStatus2("2"); // 二作无匹配
//                                paper.setFirstAuthorId(firstAuthor.getWorkId());
//                                paper.setSecondAuthorId(null);
//                            } else {
//                                String[] tutorNicknames = tutor.getNicknames().split(";");
//                                // 验证学生导师在论文的作者列表中
//                                boolean flag = false;
//                                for (String nickname : tutorNicknames) {
//                                    if (authorList.contains(nickname)) {
//                                        flag = true;
//                                        break;
//                                    }
//                                }
//                                paper.setStatus("2"); // 整体成功
//                                paper.setStatus1("0"); // 一作成功
//                                paper.setFirstAuthorId(firstAuthor.getWorkId());
//                                if (flag) {
//                                    paper.setStatus2("0"); // 二作成功
//                                    paper.setSecondAuthorId(tutor.getWorkId());
//                                } else {
//                                    paper.setStatus2("2"); // 二作无匹配
//                                    paper.setSecondAuthorId(null);
//                                }
//                            }
//                        } else {
//                            paper.setStatus("1"); // 整体出错
//                            paper.setStatus1("2"); // 一作无匹配
//                            paper.setStatus2("2"); // 二作无匹配
//                            paper.setFirstAuthorId(null);
//                            paper.setSecondAuthorId(null);
//                        }
//                    }
//                    // 过滤后唯一
//                    else if (_matchList1.size() == 1) {
//                        User firstAuthor = _matchList1.get(0);
//                        User tutor = firstAuthor.getTutor();
//                        if (tutor == null) {
//                            paper.setStatus("2"); // 整体成功(学生信息中无导师)
//                            paper.setStatus1("0"); // 一作成功
//                            paper.setStatus2("2"); // 二作无匹配
//                            paper.setFirstAuthorId(firstAuthor.getWorkId());
//                            paper.setSecondAuthorId(null);
//                        } else {
//                            String[] tutorNicknames = tutor.getNicknames().split(";");
//                            // 验证学生导师在论文的作者列表中
//                            boolean flag = false;
//                            for (String nickname : tutorNicknames) {
//                                if (authorList.contains(nickname)) {
//                                    flag = true;
//                                    break;
//                                }
//                            }
//                            paper.setStatus("2"); // 整体成功
//                            paper.setStatus1("0"); // 一作成功
//                            paper.setFirstAuthorId(firstAuthor.getWorkId());
//                            if (flag) {
//                                paper.setStatus2("0"); // 二作成功
//                                paper.setSecondAuthorId(tutor.getWorkId());
//                            } else {
//                                paper.setStatus2("2"); // 二作无匹配
//                                paper.setSecondAuthorId(null);
//                            }
//                        }
//                    }
//                    // 过滤后无匹配或匹配数量大于1
//                    else {
//                        paper.setStatus("1"); // 整体出错
//                        paper.setStatus1("2"); // 一作无匹配
//                        paper.setStatus2("2"); // 二作无匹配
//                        paper.setFirstAuthorId(null);
//                        paper.setSecondAuthorId(null);
//                    }
//                }
//                // 混合
//                else {
//                    // 按学院过滤
//                    List<User> _matchlist1 = new ArrayList<>();
//                    for (User user : matchList1) {
//                        if (user.getSchool().equals(paper.getDanweiCN())) {
//
//                        }
//                    }
//                    paper.setStatus("1"); // 整体出错
//                    paper.setStatus1("2"); // 一作无匹配
//                    paper.setStatus2("2"); // 二作无匹配
//                    paper.setFirstAuthorId(null);
//                    paper.setSecondAuthorId(null);
//                }
//            }
//        }
//        paperDao.updateBatch(paperList);
//        return true;
//    }

    /**
     * 删除某个状态下的所有论文
     */
    @RequestMapping(value = "deleteByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByStatus(@RequestParam("status") String status) {
        paperService.deleteByStatus(status);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * 手动选择论文的第一或第二作者
     */
    @RequestMapping(value = "selectAuthor", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAuthor(
            @RequestParam("paperId") String paperId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("authorWorkId") String authorWorkId) {
        paperService.selectAuthor(paperId, authorIndex, authorWorkId);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
