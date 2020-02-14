package team.abc.ssm.modules.tutor.paper.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import team.abc.ssm.modules.sys.dao.FunctionDao;
import team.abc.ssm.modules.tutor.paper.dao.TutorPaperMapper;
import team.abc.ssm.modules.tutor.paper.entity.ClaimPaper;
import team.abc.ssm.modules.tutor.paper.entity.TutorPaper;

@Service
public class TutorService {

    @Autowired
    TutorPaperMapper tutorPaperMapper;

    @Autowired
    FunctionDao functionDao;

    public List<TutorPaper> selectTutorPaperListByPage(TutorPaper tutorPaper) {
        //获取作者的所有论文
        return tutorPaperMapper.selectTheAuthorPapers(tutorPaper);
    }

    public int getTutorPaperNum(String authorWorkId) {
        return tutorPaperMapper.selectTheAuthorPaperNum(authorWorkId);
    }

    public  List<TutorPaper> selectTutorPaperByWosId(String WosId){
        TutorPaper tutorPaper = new TutorPaper();
        tutorPaper.setStoreNum(WosId);
        return tutorPaperMapper.selectPaperByWosId(tutorPaper);
    }

    public List<String> getOrgList() {
        return functionDao.getOrgList();
    }

    //导师认领
    public Integer tutorClaimPaper(ClaimPaper claimPaper){
        //认领过的不能再次认领
        int n = 0;
        n= tutorPaperMapper.isPaperBeenClaimed(claimPaper);
        if( n > 0 ){
            return -2;
        }else{
            n = tutorPaperMapper.tutorClaimPaper(claimPaper);
            if( n == 0 ) return -1;
            else return 1;
        }
    }

    //管理员管理
    @Transactional
    public Integer doTutorClaim(ClaimPaper claimPaper){
        if(tutorPaperMapper.updateClaimStatus(claimPaper) == 1){
            if(tutorPaperMapper.updatePaperInfo(claimPaper.getTutorPaper().get(0)) >= 1){
                return 1;
            }else return -1;
        }else{
            return -1;
        }
    }

    public List<ClaimPaper> getTutorClaimHistory(ClaimPaper claimPaper){
        List<ClaimPaper> claimPapers =  tutorPaperMapper.getTutorClaimHistory(claimPaper);
        for (ClaimPaper cp :claimPapers){
            TutorPaper tutorPaper =new TutorPaper();
            tutorPaper.setStoreNum(cp.getPaperWosId());
            List<TutorPaper> tutorPapers = tutorPaperMapper.selectPaperByWosId(tutorPaper);

            tutorPaper.setStoreNum("");
            tutorPaper.setPaperName("申请信息");
            tutorPaper.setFirstAuthorName(cp.getFirstAuthorName());
            tutorPaper.setFirstAuthorType(cp.getFirstAuthorType());
            tutorPaper.setFirstAuthorSchool(cp.getFirstAuthorSchool());
            tutorPaper.setSecondAuthorName(cp.getSecondAuthorName());
            tutorPaper.setSecondAuthorType(cp.getSecondAuthorType());
            tutorPaper.setSecondAuthorSchool(cp.getSecondAuthorSchool());

            tutorPapers.add(tutorPaper);
            cp.setTutorPaper(tutorPapers);
        }
        return claimPapers;
    }
}
