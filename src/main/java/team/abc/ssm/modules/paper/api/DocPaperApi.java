package team.abc.ssm.modules.paper.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.service.DocPaperService;
import team.abc.ssm.modules.sys.service.DictService;

import java.util.List;

/**
 * @ClassName DocPaperApi
 * @Description 论文实体
 * @Author zm
 * @Date 2019/8/5 11:15
 * @Version 1.0
 **/
@Controller
@RequestMapping("/api/paper")
public class DocPaperApi extends BaseApi {
    @Autowired
    private DocPaperService docPaperService;

    @Autowired
    private DictService dictService;

    /**
     * 获取指定作者下的所有论文List
     * 1.传入参数的
     *
     * @author zm
     * @param1 paper
     * @return java.lang.Object
     * @date 2019/8/5 11:18
     **/
    @RequestMapping(value = "selectMyPaperByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByPage(
            @RequestBody DocPaper docPaper
    ){
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<DocPaper> myPaperList = docPaperService.selectMyPaperListByPage(docPaper);
        //2.获取当前作者论文总数(根据作者工号)
        int myPaperNum = docPaperService.getMyPaperNum(docPaper.getTheAuthorWorkId());

        Page<DocPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperNum);
        return retMsg.Set(MsgType.SUCCESS,paperResPage);
    }


    /**
     * 根据筛选条件获取相应的论文List
     *
     * @author zm
     * @param1 condition
     * @return java.lang.Object        
     * @date 2019/8/9 19:08
     **/
    @RequestMapping(value = "selectAllPaperByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllPaperByPage(
            @RequestBody StatisticCondition condition
    ){
        //1.设置待查询的论文List的状态为：已完成
        condition.setStatus("3");
        //2.reset一下论文的种类
        condition.setPaperType(dictService.getDictNameEnById(condition.getPaperType()));
        //3.分页查询paperList
        List<DocPaper> paperList = docPaperService.selectAllPaperByPage(condition);
        //4.查询总数目
        int paperNum = docPaperService.selectAllPaperNum(condition);

        Page<DocPaper> paperResPage = new Page<>();
        paperResPage.setResultList(paperList);
        paperResPage.setTotal(paperNum);

        return retMsg.Set(MsgType.SUCCESS,paperResPage);
    }
}