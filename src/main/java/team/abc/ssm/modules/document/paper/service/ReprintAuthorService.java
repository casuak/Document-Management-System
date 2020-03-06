package team.abc.ssm.modules.document.paper.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.document.paper.dao.ReprintAuthorDao;
import team.abc.ssm.modules.document.paper.entity.Paper;
import team.abc.ssm.modules.document.paper.entity.ReprintAuthorEntry;
import team.abc.ssm.modules.sys.entity.User;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class ReprintAuthorService {
    @Autowired
    private ReprintAuthorDao reprintAuthorDao;

    //显示论文
    public List<Paper> selectListByPage(Paper paper) {
        List<Paper> list = reprintAuthorDao.selectListByPage(paper);
        for (Paper p : list) {
            if (p.getRPStatus().equals("1") ||
                    p.getRPStatus().equals("2") ||
                    p.getRPStatus().equals("4")) {
                List<User> authors = reprintAuthorDao.getAuthorInfoByPaperId(p.getId());
                StringBuilder str = new StringBuilder();
                for (User u : authors) {
                    str.append(u.getRealName()).append("(").
                            append(u.getWorkId()).append(", ").
                            append(u.getUserType()).append("); ");
                }
                p.setMatchedAuthor(str.toString());
            }
        }
        return list;
    }

    public int selectSearchCount(Paper paper) {
        return reprintAuthorDao.selectSearchCount(paper);
    }

    //展示匹配情况
    public List<ReprintAuthorEntry> showMatch(Paper paper) {
        //todo 或许可以在xml里写？
        return null;
    }

    /**
     * @param
     * @return void
     * @Description 初始化论文，找到北理的作者
     * @author zch
     * @date 2020/2/6 19:57
     */
    public void init() {
        //获取未初始化的论文
        List<Paper> papers = reprintAuthorDao.getPaperByStatus("-1");

        //逐条处理
        for (Paper p : papers) {
            Set<String> set = getBITAuthor(p.getRPImport());
            if (set.size() == 0) {
                //没有北理的作者
                p.setRPStatus("3");
            } else {
                StringBuilder str = new StringBuilder();
                for (String s : set) {
                    str.append(s).append(";");
                }
                p.setRPStatus("0");
                p.setRPBIT(str.toString());
            }

            //写入数据库
            p.preUpdate();
            reprintAuthorDao.updatePaperById(p);
        }
    }

    /**
     * @param
     * @return void
     * @Description 通讯作者自动匹配
     * @author zch
     * @date 2020/2/6 22:33
     */
    public void autoMatch() {
        //获取所有论文
        List<Paper> list = reprintAuthorDao.getPaperByStatus("0");

        //获取所有用户工号、姓名对应关系，去除无姓名的用户（如管理员）
        List<User> users = reprintAuthorDao.getAllUsers();
        for (User u : users) {
            String nickname = u.getNicknames();
            if (nickname == null || nickname.equals("")) {
                users.remove(u);
                continue;
            }
            String[] split = nickname.split(";");
            u.setNicknames(split[2].trim());
        }

        //待更新、插入列表
        List<Paper> toUpdatePaper = new ArrayList<>();
        List<ReprintAuthorEntry> toInsertEntry = new ArrayList<>();

        int num;//姓名匹配的用户数量
        int sameCollege;//同学院重名作者数
        String workId = null;//工号
        String sameCollegeWorkId = null;//同学院作者工号
        String name = null;//姓名
        String sameCollegeName = null;//同学院姓名
        ReprintAuthorEntry entry;//匹配记录

        for (Paper p : list) {
            boolean isSuccess = true;//每个作者是否都唯一匹配
            String first = p.getFirstAuthorId();//一作工号
            String second = p.getSecondAuthorId();//二作工号
            String[] authors = p.getRPBIT().split(";");
            String school = p.getDanweiCN();//学院

            //对于每一个作者
            for (String author : authors) {
                boolean hasMatched = false;//是否可以精确匹配
                num = 0;
                sameCollege = 0;
                for (User u : users) {
                    if (u.getNicknames().equals(author.trim().toLowerCase())) {
                        if (u.getWorkId().equals(first) || u.getWorkId().equals(second)) {//与第一、二作者匹配上
                            entry = new ReprintAuthorEntry(p.getId(), author.trim(), u.getWorkId(), u.getRealName(), "0");
                            toInsertEntry.add(entry);
                            hasMatched = true;
                            break;
                        } else {
                            num++;
                            if (u.getSchool().equals(school)) {//匹配学院
                                sameCollege++;
                                sameCollegeWorkId = u.getWorkId();
                                sameCollegeName = u.getRealName();
                            }
                            workId = u.getWorkId();
                            name = u.getRealName();
                        }
                    }
                }
                if (hasMatched)
                    continue;

                if (num == 0) {//没有匹配
                    p.setRPStatus("2");
                    isSuccess = false;
                    entry = new ReprintAuthorEntry(p.getId(), author.trim(), "-", "-", "-1");
                } else if (num == 1) {//唯一匹配
                    entry = new ReprintAuthorEntry(p.getId(), author.trim(), workId, name, "0");
                } else if (sameCollege == 1 && sameCollegeWorkId != null) {//多个匹配，但同学院唯一
                    entry = new ReprintAuthorEntry(p.getId(), author.trim(), sameCollegeWorkId, sameCollegeName, "0");
                } else {//多个匹配
                    p.setRPStatus("2");
                    isSuccess = false;
                    entry = new ReprintAuthorEntry(p.getId(), author.trim(), "-", "-", "-2");
                }
                toInsertEntry.add(entry);
            }
            if (isSuccess)
                p.setRPStatus("1");
            toUpdatePaper.add(p);
        }

        //更新、插入
        for (Paper p : toUpdatePaper) {
            p.preUpdate();
            reprintAuthorDao.updatePaperById(p);
        }
        for (ReprintAuthorEntry e : toInsertEntry) {
            e.preInsert();
            reprintAuthorDao.insertEntry(e);
        }
    }

    //手动修改

    //删除记录

    /**
     * @param s RP列数据
     * @return 作者列表
     * @Description 得到北理工的通讯作者，并且去重
     * @author zch
     * @date 2020/2/6 20:16
     * 备选正则表达式 (.*?\(reprint author\).*?\.;)+?
     */
    private Set<String> getBITAuthor(String s) {
        Set<String> ret = new HashSet<>();
        if (s == null)
            return ret;

        List<String> tmp = new ArrayList<>();
        String[] split = s.split(";");
        for (String value : split) {
            if (value.contains("(reprint author)")) {//包含单位信息
                if (value.contains("Beijing Inst Technol")) {//北理工
                    ret.addAll(tmp);
                    ret.add(value.substring(0, value.indexOf("(")).trim());
                }
                tmp.clear();
            } else {//仅姓名
                tmp.add(value.trim());
            }
        }
        return ret;
    }

    public boolean deletePaperEntryByIds(List<Paper> list) {
        int num = 0;
        for (Paper p : list) {
            if (reprintAuthorDao.deletePaperEntryById(p.getId()) == 1)
                num++;
        }
        return num == list.size();
    }

    public void deleteFundByStatus(String status) {
        reprintAuthorDao.deletePaperEntryByStatus(status);
    }

    public boolean completePaperEntryById(List<Paper> list) {
        int num = 0;
        for (Paper p : list) {
            if (reprintAuthorDao.completePaperEntryById(p.getId()) == 1)
                num++;
        }
        return num == list.size();

        //todo 统计相关
    }

    public void completePaperEntryByStatus(String status) {
        reprintAuthorDao.completePaperEntryByStatus(status);

        //todo 统计相关
    }

    public boolean rollBackToSuccessById(List<Paper> list) {
        int num = 0;
        for (Paper p : list) {
            if (reprintAuthorDao.rollBackToSuccessById(p.getId()) == 1)
                num++;
        }
        return num == list.size();

        //todo 统计相关
    }

    public List<ReprintAuthorEntry> getMatchEntryById(String id) {
        return reprintAuthorDao.getMatchEntryById(id);
    }

    public void updateMatchEntryByPaperId(List<ReprintAuthorEntry> list, String paper) {
        reprintAuthorDao.updatePaperRPStatusById(paper);
        reprintAuthorDao.deleteEntryByPaperId(paper);
        if (list.size() == 1 &&
                (list.get(0).getAuthorWorkId() == null ||
                        list.get(0).getAuthorWorkId().equals(""))) {//全部删除
            return;
        }
        for (ReprintAuthorEntry entry : list) {
            entry.preInsert();
            reprintAuthorDao.insertEntry(entry);
        }
    }
}
