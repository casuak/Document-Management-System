package team.abc.ssm.modules.doc.api;

import net.sf.json.JSONArray;
import org.apache.http.client.utils.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.doc.service.FundService;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.doc.service.PatentService;
import team.abc.ssm.modules.paper.service.DocPaperService;
import team.abc.ssm.modules.patent.service.DocPatentService;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.service.DictService;
import team.abc.ssm.modules.sys.service.FunctionService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description 文献统计
 * @data 2019/5/8
 */
@Controller
@RequestMapping("/api/doc/statistic")
public class DocStatisticApi extends BaseApi {

    @Autowired
    private PaperSearchService paperSearchService;

    @Autowired
    private PatentService patentService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private FunctionService functionService;

    @Autowired
    private DocPaperService docPaperService;

    @Autowired
    private DocPatentService docPatentService;

    @Autowired
    private DictService dictService;

    @Autowired
    private FundService fundService;

    @RequestMapping(value = "getFundTypeList",method = RequestMethod.POST)
    @ResponseBody
    public Object getFundTypeList(){
        List<String> list = fundService.getFundTypeList();
        return retMsg.Set(MsgType.SUCCESS, list);
    }

    /**跳转到统计页面，并传相关参数到页面*/
    @RequestMapping(value = "goDocStatistic",method = RequestMethod.GET)
    public ModelAndView goDocStatistic(
            ModelAndView modelAndView
    ){
        modelAndView.setViewName("functions/doc/statistic/docStatistic");

        List<Map<String, String>> paperType = paperSearchService.getPaperType();
        List<String> patentType = docPatentService.getAllPatentType();
        List<String> orgList = functionService.getOrgList();
        List<String> subjectList = authorService.getSubList();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));
        modelAndView.addObject("patentType", JSONArray.fromObject(patentType));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));

        return modelAndView;
    }

    /** 统计搜索 */
    @RequestMapping(value = "doDocStatistic",method = RequestMethod.POST)
    @ResponseBody
    public Object doDocStatistic(
            @RequestBody StatisticCondition statisticCondition){
        Map<String,Integer> resMap = new HashMap<>();
        Map<String,Integer> paperMap,patentMap,fundMap;

        //1.处理一下paperType
        if (statisticCondition.getPaperType() != null && !"".equals(statisticCondition.getPaperType())){
            statisticCondition.setPaperType(dictService.getDictNameEnById(statisticCondition.getPaperType()));
        }

        paperMap = docPaperService.doPaperStatistics(statisticCondition);
        resMap.putAll(paperMap);
        patentMap = docPatentService.doPatentStatistics(statisticCondition);
        resMap.putAll(patentMap);
        fundMap = fundService.doFundStatistics(statisticCondition);
        resMap.putAll(fundMap);

        return retMsg.Set(MsgType.SUCCESS,resMap);
    }

    @RequestMapping(value = "/exportStatisticExcel",method = RequestMethod.GET)
    public void exportStatisticExcel(
            @RequestParam("studentPaper") Integer studentPaper,
            @RequestParam("teacherPaper") Integer teacherPaper,
            @RequestParam("doctorPaper") Integer doctorPaper,
            @RequestParam("totalPaper") Integer totalPaper,
            @RequestParam("studentPatent") Integer studentPatent,
            @RequestParam("teacherPatent") Integer teacherPatent,
            @RequestParam("doctorPatent") Integer doctorPatent,
            @RequestParam("totalPatent") Integer totalPatent,
            @RequestParam("teacherFund")Integer totalFund,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws Exception {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("文献统计结果");
        String[] excelHeader = {"序号", "文献类型", "文献总数目", "教师文献数目","学生文献数目","博士后文献数目"};

        // 单元格列宽
        int[] excelHeaderWidth = {80, 200, 200, 150, 150, 150};

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
        font.setFontHeightInPoints((short)12); //设置字体大小
        style1.setFont(font);
        style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
        style1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中

        // 合并单元格
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 2, 2));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 3, 3));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 4, 4));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 5, 5));


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

        //循环列表数据，逐个添加
        for (int i = 0; i < 4; i++) {
            row = sheet.createRow(i + 2);
            int cellNum = 0;
            HSSFCell cell = row.createCell(cellNum++);
            if(i != 3){
                cell.setCellValue(i + 1);
            }else{
                cell.setCellValue("合计");
            }
            cell.setCellStyle(style);
            if (i == 0){
                cell = row.createCell(cellNum++);
                cell.setCellValue("论文");
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(totalPaper);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(teacherPaper);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(studentPaper);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum);
                cell.setCellValue(doctorPaper);
                cell.setCellStyle(style);
            }else if (i==1){
                cell = row.createCell(cellNum++);
                cell.setCellValue("专利");
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(totalPatent);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(teacherPatent);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(studentPatent);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum);
                cell.setCellValue(doctorPatent);
                cell.setCellStyle(style);
            }else if (i==2){
                cell = row.createCell(cellNum++);
                cell.setCellValue("基金");
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(totalFund);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(totalFund);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(0);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum);
                cell.setCellValue(0);
                cell.setCellStyle(style);
            }else {
                cell = row.createCell(cellNum++);
                cell.setCellValue("");
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(totalPaper + totalPatent+totalFund);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(teacherPaper + teacherPatent+totalFund);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum++);
                cell.setCellValue(studentPaper + studentPatent);
                cell.setCellStyle(style);

                cell = row.createCell(cellNum);
                cell.setCellValue(doctorPaper + doctorPatent);
                cell.setCellStyle(style);
            }
        }

        httpServletResponse.setContentType("application/vnd.ms-excel");

        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String( "文献统计结果".getBytes( "gb2312" ), "ISO8859-1" )
                        + DateUtils.formatDate(new Date(), "yyyyMMddHHmmss") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }
}