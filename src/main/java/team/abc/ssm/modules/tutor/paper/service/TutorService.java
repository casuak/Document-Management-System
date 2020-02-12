package team.abc.ssm.modules.tutor.paper.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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

    public List<ClaimPaper> getTutorClaimHistory(ClaimPaper claimPaper){
        return tutorPaperMapper.getTutorClaimHistory(claimPaper);
    }
}
