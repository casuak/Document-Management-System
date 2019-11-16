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

    // 将所有匹配成功状态的论文转入完成状态
    @RequestMapping(value = "completeAll", method = RequestMethod.POST)
    @ResponseBody
    public Object completeAll() {
        paperService.completeAll();
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * step2
     */
    @RequestMapping(value = "paperUserMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object paperUserMatch() {
        try {
            paperService.paperUserMatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

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

    /**
     * @param
     * @return java.lang.Object
     * @Description 手工匹配论文
     * @author zch
     * @date 2019/11/16 13:31
     */
    @RequestMapping(value = "completeImportPaper", method = RequestMethod.POST)
    @ResponseBody
    public Object completeImportPaper() {
        if (paperService.completeImportPaper())
            return retMsg.Set(MsgType.SUCCESS);
        else
            return retMsg.Set(MsgType.ERROR);
    }
}
