package team.abc.ssm.modules.patent.api;

import net.sf.json.JSONArray;
import org.apache.http.client.utils.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.service.DocPatentService;
import team.abc.ssm.modules.sys.service.FunctionService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/api/patent")
public class DocPatentApi extends BaseApi {

    @Autowired
    private DocPatentService patentService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private FunctionService functionService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody DocPatent patent) {
        Page<DocPatent> data = new Page<>();
        data.setResultList(patentService.selectListByPage(patent));
        data.setTotal(patentService.selectSearchCount(patent));
        return new AjaxMessage().Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<DocPatent> patentList) {
        patentService.deleteListByIds(patentList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/7/3 10:19
     * @params [status]
     * @return: java.lang.Object
     * @Description //删除某个状态下的所有专利
     **/
    @RequestMapping(value = "deletePatentByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deletePatentByStatus(@RequestParam("status") String status) {
        patentService.deleteByStatus(status);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/7/3 10:23
     * @params [patentId, authorIndex, authorId]
     * @return: java.lang.Object
     * @Description //手动设置专利的第一作者或第二作者
     **/
    @RequestMapping(value = "setPatentAuthor", method = RequestMethod.POST)
    @ResponseBody
    public Object setPatentAuthor(
            @RequestParam("patentId") String patentId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("authorId") String authorId) {
        int res = patentService.setPatentAuthor(patentId, authorIndex, authorId);
        if (res == 1){
            return retMsg.Set(MsgType.SUCCESS);
        }else {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    /**
     * @author zm
     * @date 2019/7/3 9:33
     * @params []
     * @return: java.lang.Object
     * @Description //step1：初始化所有未初始化的专利
     **/
    @RequestMapping(value = "initAllPatent", method = RequestMethod.POST)
    @ResponseBody
    public Object initAllPatent() throws ParseException {
        System.out.println("----initAllPatent----start----");
        patentService.initialPatent();
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/7/3 10:16
     * @params []
     * @return: java.lang.Object
     * @Description //step2：对所有已初始化的专利进行用户匹配，并返回匹配的结果
     **/
    @RequestMapping(value = "patentUserMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object patentUserMatch() {
        Map<String, Integer> matchResult = new HashMap<>();
        try {
            matchResult = patentService.patentUserMatch();
        } catch (Exception e){
            e.printStackTrace();
        }
        return retMsg.Set(MsgType.SUCCESS,matchResult);
    }

    /**
     * @author zm
     * @date 2019/7/3 14:56
     * @params [patentList]
     * @return: java.lang.Object
     * @Description //把专利状态设置成2(匹配成功)
     **/
    @RequestMapping(value = "convertToSuccessByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object convertToSuccessByIds(@RequestBody List<DocPatent> patentList) {
        patentService.convertToSuccessByIds(patentList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/8/4 14:57
     * @params []
     * @return: java.lang.Object
     * @Description //把专利状态设置成2(匹配成功)___全部已完成匹配的专利
     **/
    @RequestMapping(value = "convertToCompleteAll",method = RequestMethod.POST)
    @ResponseBody
    public Object convertToCompleteAll(){
        if (patentService.convertToCompleteAll()){
            return retMsg.Set(MsgType.SUCCESS);
        }else {
            return retMsg.Set(MsgType.ERROR);
        }
    }
    /**
     * @author zm
     * @date 2019/7/5 9:31
     * @params [patentList]
     * @return: java.lang.Object
     * @Description //根据传来的专利list，把专利状态设置成4(匹配完成)，并且插入新的记录在mapUserPatent中。
     **/
    @RequestMapping(value = "convertToCompleteByIds",method = RequestMethod.POST)
    @ResponseBody
    public Object convertToCompleteByIds(
            @RequestBody List<DocPatent> patentList){
        System.out.println("--------------------------zhuanru wancheng ");
        System.out.println(patentList);
        //更改专利的状态
        patentService.convertToCompleteByIds(patentList);
        //插入记录——mapUserPatent
        //patentService.insertPatentMapRecord(ids);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "changeInstitute", method = RequestMethod.POST)
    @ResponseBody
    public Object changeInstitute(
            @RequestParam("patentId") String patentId,
            @RequestParam("institute") String institute){
        patentService.changeInstitute(patentId,institute);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/8/4 16:31
     * @params [sysUser]
     * @return: java.lang.Object
     * @Description //获取当前作者的全部专利(返回分页)
     *
     * docPatent.firstAuthorId暂存作者id
     * docPatent.secondAuthorId暂存作者工号
     * docPatent.page存贮所需分页
     **/
    @RequestMapping(value = "selectMyPatentByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPatentByPage(
            @RequestBody DocPatent docPatent){
        //1.提取暂存在docPatent中的authorId，和authorWorkId信息
        String authorId = docPatent.getFirstAuthorId();
        String authorWorkId = docPatent.getSecondAuthorId();
        //2.获取专利列表
        List<DocPatent> myPatentList = patentService.selectMyPatentListByPage(authorWorkId,docPatent);
        //3.获取专利总数
        int myPatentNum = patentService.getMyPatentNum(authorWorkId);
        //4.构造返回分页
        Page<DocPatent> myPatentPage = new Page<>();
        myPatentPage.setResultList(myPatentList);
        myPatentPage.setTotal(myPatentNum);
        System.out.println("-----专利page----");
        System.out.println(myPatentPage);
        AjaxMessage retMsg = new AjaxMessage();
        return retMsg.Set(MsgType.SUCCESS,myPatentPage);
    }

    /*查看专利统计详情*/
    @RequestMapping(value = "selectPatentListByPageGet", method = RequestMethod.GET)
    public Object selectPatentListByPageGet(
            @RequestParam(value = "subject") String subject,
            @RequestParam(value = "institute") String institute,
            @RequestParam(value = "startDate") String startDate,
            @RequestParam(value = "endDate") String endDate,
            @RequestParam(value = "patentType") String patentType,
            ModelAndView modelAndView
    ) {
        //获取专利所有类别
        List<String> patentTypeList = patentService.getAllPatentType();
        //获取学科类别
        List<String> subjectList = authorService.getSubList();
        //获取机构(学院)类别
        List<String> orgList = functionService.getOrgList();

        modelAndView.setViewName("functions/doc/docManage/patentList");

        modelAndView.addObject("patentTypeList", JSONArray.fromObject(patentTypeList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));

        modelAndView.addObject("subject",subject);
        modelAndView.addObject("institute",institute);
        modelAndView.addObject("startDate",startDate);
        modelAndView.addObject("endDate",endDate);
        modelAndView.addObject("patentType",patentType);

        return modelAndView;
    }

    @RequestMapping(value = "selectAllPatentByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllPatentByPage(
            @RequestBody StatisticCondition condition
    ) {
        //1.设置待查询的专利List的状态为：已完成
        condition.setStatus(PatentMatchType.MATCH_FINISHED.toString());
        //2.分页查询patentList
        List<DocPatent> patentList = patentService.selectListByPageWithStatisticCondition(condition);
        //3.查询总数目
        int patentNum = patentService.selectNumWithStatisticCondition(condition);

        Page<DocPatent> patentResPage = new Page<>();
        patentResPage.setResultList(patentList);
        patentResPage.setTotal(patentNum);

        System.out.println(patentResPage);

        return retMsg.Set(MsgType.SUCCESS, patentResPage);
    }

    @RequestMapping(value = "/exportPatentList", method = RequestMethod.GET)
    public void exportPaperList(
            @RequestParam("subject") String subject,
            @RequestParam("institute") String institute,
            @RequestParam("patentName") String patentName,
            @RequestParam("patentType") String patentType,
            @RequestParam("patentNumber") String patentNumber,
            @RequestParam("firstAuthorWorkId") String firstAuthorWorkId,
            @RequestParam("secondAuthorWorkId") String secondAuthorWorkId,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        StatisticCondition statisticCondition = new StatisticCondition();
        //1.状态为已完成
        statisticCondition.setStatus(PatentMatchType.MATCH_FINISHED.toString());
        //2.设置其他的查询筛选条件
        statisticCondition.setSubject(subject);
        statisticCondition.setInstitute(institute);
        statisticCondition.setPatentName(patentName);
        statisticCondition.setPaperType(patentType);
        statisticCondition.setPatentNumber(patentNumber);
        statisticCondition.setFirstAuthorWorkId(firstAuthorWorkId);
        statisticCondition.setSecondAuthorWorkId(secondAuthorWorkId);
        if (!"NaN-NaN-NaN".equals(startDate)) {
            statisticCondition.setStartDate(sdf.parse(startDate));
        }
        if (!"NaN-NaN-NaN".equals(endDate)) {
            statisticCondition.setEndDate(sdf.parse(endDate));
        }
        //4.直接查询符合条件的patentList(statisticCondition中不含page，所以不会有分页的数目限制)
        List<DocPatent> patentList = patentService.selectListByPageWithStatisticCondition(statisticCondition);
        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("专利统计结果");
        String[] excelHeader = {
                "序号", "专利名称", "所属学院", "专利种类", "专利授权日",
                "第一作者", "第一作者工号", "第一作者类型", "第二作者", "第二作者工号", "第二作者类型", "作者列表"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 300, 180, 100, 180,
                160, 150, 120, 160, 150, 120, 400
        };

        HSSFRow row = sheet.createRow((int) 0);
        HSSFCellStyle style = wb.createCellStyle();
        // 设置居中样式
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中
        // 设置合计样式
        HSSFCellStyle style1 = wb.createCellStyle();
        Font font = wb.createFont();
        font.setColor(HSSFColor.BLACK.index);
        font.setBoldweight(Font.BOLDWEIGHT_BOLD); // 粗体
        font.setFontHeightInPoints((short) 12); //设置字体大小
        style1.setFont(font);
        style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
        style1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中

        // 设置列宽度（像素）
        for (int i = 0; i < excelHeaderWidth.length; i++) {
            sheet.setColumnWidth(i, 32 * excelHeaderWidth[i]);
        }
        // 添加表格头
        for (int i = 0; i < excelHeader.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }
        row = sheet.createRow((int) 1);

        for (int i = 0; i < patentList.size(); i++) {
            row = sheet.createRow(i + 1);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i);
            cell.setCellStyle(style);
            //第2列：专利名称
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getPatentName());
            cell.setCellStyle(style);

            //第6列：一级学科
            /*cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getPatentSubject());
            cell.setCellStyle(style);*/
            //第7列：所属学院
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getInstitute());
            cell.setCellStyle(style);
            //第8列：论文种类
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getPatentType());
            cell.setCellStyle(style);
            //第9列：出版日期
            cell = row.createCell(cellNum++);
            cell.setCellValue(sdf.format(patentList.get(i).getPatentAuthorizationDate()));
            cell.setCellStyle(style);
            //第10列：第一作者
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getFirstAuthorName());
            cell.setCellStyle(style);
            //第11列：第一作者工号
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getFirstAuthorWorkId());
            cell.setCellStyle(style);
            //第12列：第一作者类型
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getFirstAuthorType());
            cell.setCellStyle(style);
            //第13列：第二作者
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getSecondAuthorName());
            cell.setCellStyle(style);
            //第14列：第二作者工号
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getSecondAuthorWorkId());
            cell.setCellStyle(style);
            //第15列：第二作者类型
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getSecondAuthorType());
            cell.setCellStyle(style);
            //第17列：作者列表
            cell = row.createCell(cellNum++);
            cell.setCellValue(patentList.get(i).getAuthorList());
            cell.setCellStyle(style);
        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("专利统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }
}
