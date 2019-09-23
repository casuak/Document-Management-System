package team.abc.ssm.modules.doc.api;


import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.doc.service.FundService;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.sys.service.FunctionService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("api/doc/fund/")
public class FundApi extends BaseApi {
    @Autowired
    private FundService fundService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private FunctionService functionService;

    @RequestMapping(value = "initFirst", method = RequestMethod.POST)
    @ResponseBody
    public Object init() {
        fundService.init();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "list", method = RequestMethod.POST)
    @ResponseBody
    public Object list(@RequestBody Fund fund) {
        Page<Fund> data = new Page<>();
        data.setResultList(fundService.list(fund));
        data.setTotal(fundService.listCount(fund));
        return new AjaxMessage().Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "deleteByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByIds(@RequestBody List<Fund> list) {
        fundService.deleteByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteFundByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteFundByStatus(@RequestParam("status") String status) {
        fundService.deleteFundByStatus(status);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "initAllFund", method = RequestMethod.POST)
    @ResponseBody
    public Object initAllFund() {
        System.out.println("----initAllFund----start----");
        fundService.initFund();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "matchUserFund", method = RequestMethod.POST)
    @ResponseBody
    public Object matchUserFund() {
        System.out.println("----matchUserFund----start----");
        fundService.matchUserFund();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "updateFund", method = RequestMethod.POST)
    @ResponseBody
    public Object updateFund(@RequestBody Fund fund) {
        if (fundService.updateFund(fund))
            return retMsg.Set(MsgType.SUCCESS);
        else return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "searchForMatch")
    @ResponseBody
    public Object searchForMatch(@RequestParam("id") String id,
                                 @RequestParam("name") String name) {
        List<SysUser> findById = fundService.findById(id);
        List<SysUser> findByName = fundService.findByName(name);
        findById.addAll(findByName);
        return findById;
    }

    @RequestMapping(value = "matchFund", method = RequestMethod.POST)
    @ResponseBody
    public Object matchFund(@RequestBody Fund fund) {
        if (fundService.matchFund(fund))
            return retMsg.Set(MsgType.SUCCESS);
        else return retMsg.Set(MsgType.ERROR);
    }

    /*查看基金统计详情*/
    @RequestMapping(value = "selectFundListByPageGet", method = RequestMethod.GET)
    public Object selectFundListByPageGet(
            @RequestParam(value = "institute") String institute,
            @RequestParam(value = "fundType") String fundType,
            ModelAndView modelAndView
    ) {
        //获取专利所有类别
        List<String> fundTypeList = fundService.getFundTypeList();
        //获取机构(学院)类别
        List<String> orgList = functionService.getOrgList();

        modelAndView.setViewName("functions/doc/docManage/fundList");

        modelAndView.addObject("fundTypeList", JSONArray.fromObject(fundTypeList));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));


        modelAndView.addObject("institute", institute);
        modelAndView.addObject("fundType", fundType);

        return modelAndView;
    }

    @RequestMapping(value = "selectAllFundByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllFundByPage(@RequestBody StatisticCondition condition) {
        //1.设置待查询的List的状态为：已完成
        condition.setStatus("3");
        //2.分页查询
        List<Fund> fundList = fundService.selectListByPageWithStatisticCondition(condition);
        //3.查询总数目
        int fundNum = fundService.selectNumWithStatisticCondition(condition);

        Page<Fund> patentResPage = new Page<>();
        patentResPage.setResultList(fundList);
        patentResPage.setTotal(fundNum);

        System.out.println(patentResPage);

        return retMsg.Set(MsgType.SUCCESS, patentResPage);
    }

    @RequestMapping(value = "deleteFundListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Fund> list) {
        fundService.deleteListByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }


    @RequestMapping(value = "/exportFundList", method = RequestMethod.GET)
    public void exportPaperList(
            @RequestParam("institute") String institute,
            @RequestParam("type") String fundType,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Page<StatisticCondition> pages = new Page<>();
        pages.setPageStart(0);
        pages.setPageIndex(1);
        pages.setPageSize(99999);
        StatisticCondition statisticCondition = new StatisticCondition();
        //1.设置待导出的论文List的状态为：已完成
        statisticCondition.setStatus("3");
        statisticCondition.setPage(pages);
        //3.设置其他的查询筛选条件
        statisticCondition.setFundType(fundType);
        statisticCondition.setInstitute(institute);
        //4.直接查询符合条件的paperList(statisticCondition中不含page，所以不会有分页的数目限制)
        List<Fund> fundList = fundService.selectListByPageWithStatisticCondition(statisticCondition);

        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();

        HSSFSheet sheet = wb.createSheet("论文统计结果");
        String[] excelHeader = {
                "序号", "指标名称", "姓名", "工号", "年份", "项目名称", "金额（万元）"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 300, 150, 150, 150, 300, 150,
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
        // 合并单元格
       /* sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 2, 2));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 3, 3));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 4, 4));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 5, 5));*/

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

        for (int i = 0; i < fundList.size(); i++) {
            row = sheet.createRow(i + 1);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i + 1);
            cell.setCellStyle(style);
            //第2列
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getMetricName());
            cell.setCellStyle(style);
            //第3列
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getPersonName());
            cell.setCellStyle(style);

            //第4列
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getPersonWorkId());
            cell.setCellStyle(style);
            //第6列：
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getProjectYear());
            cell.setCellStyle(style);
            //第7列：
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getProjectName());
            cell.setCellStyle(style);
            //第8列：
            cell = row.createCell(cellNum++);
            cell.setCellValue(fundList.get(i).getProjectMoney());
            cell.setCellStyle(style);

        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("基金统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }

    @RequestMapping(value = "selectMyFundByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyFundByPage(
            @RequestBody Fund fund) {

        List<Fund> myFundList = fundService.selectMyPatentListByPage(fund);
        int myFundNum = fundService.getMyPatentNum(fund);

        Page<Fund> myFundPage = new Page<>();
        myFundPage.setResultList(myFundList);
        myFundPage.setTotal(myFundNum);
        AjaxMessage retMsg = new AjaxMessage();
        return retMsg.Set(MsgType.SUCCESS, myFundPage);
    }

    @RequestMapping(value = "delete", method = RequestMethod.POST)
    @ResponseBody
    public Object delete(@RequestBody List<Fund> list) {
        fundService.delete(list);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "completeFundByStatus",method = RequestMethod.POST)
    @ResponseBody
    public Object completeFundByStatus(){
        fundService.completeFundByStatus();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "completeFundByChoice",method = RequestMethod.POST)
    @ResponseBody
    public Object completeFundByChoice(@RequestBody Fund fund){
        fund.setStatus("3");
        fundService.completeFundByChoice(fund);

        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "uncompleteFundByChoice",method = RequestMethod.POST)
    @ResponseBody
    public Object uncompleteFundByChoice(@RequestBody Fund fund){
        fund.setStatus("2");
        fundService.completeFundByChoice(fund);

        return retMsg.Set(MsgType.SUCCESS);
    }
}
