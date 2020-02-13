package team.abc.ssm.modules.tutor.paper.dao;

import  java.util.List;

import team.abc.ssm.modules.tutor.paper.entity.ClaimPaper;
import team.abc.ssm.modules.tutor.paper.entity.TutorPaper;

public interface TutorPaperMapper {

    /**
     * 传入DocPaper，查询并返回指定作者的所有论文List
     * 1.DocPaper中的theAuthorWorkId为待查作者的工号
     * 2.DocPaper中的page存储的是分页信息
     * 3.需要查询的paper状态是：2(已完成)
        */
    List<TutorPaper> selectTheAuthorPapers(TutorPaper record);

    /**
        * 根据wosId查询库里论文，只能查询已匹配完成的论文
     */
    List<TutorPaper> selectPaperByWosId(TutorPaper record);
    /**
     * 传入作者的工号，查询返回其下所有的论文数量(status是‘2’)
     **/
    int selectTheAuthorPaperNum(String authorWorkId);

    /**
     * 导师认领论文
     **/
    int tutorClaimPaper(ClaimPaper claimPaper);

    /**
     * 根据工号查询导师认领论文记录
     **/
    List<ClaimPaper> getTutorClaimHistory(ClaimPaper claimPaper);

    /**
     * 同一论文只能认领一次（未通过请求不算）
     **/
    int isPaperBeenClaimed(ClaimPaper claimPaper);
}

