package team.abc.ssm.modules.paper.api;

import org.apache.http.client.utils.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.service.DocPaperService;
import team.abc.ssm.modules.sys.service.DictService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
     * @return java.lang.Object
     * @author zm
     * @param1 paper
     * @date 2019/8/5 11:18
     **/
    @RequestMapping(value = "selectMyPaperByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByPage(
            @RequestBody DocPaper docPaper
    ) {
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<DocPaper> myPaperList = docPaperService.selectMyPaperListByPage(docPaper);
        //2.获取当前作者论文总数(根据作者工号)
        int myPaperNum = docPaperService.getMyPaperNum(docPaper.getTheAuthorWorkId());

        Page<DocPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperNum);
        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }


    /**
     * 根据筛选条件获取相应的论文List
     *
     * @return java.lang.Object
     * @author zm
     * @param1 condition
     * @date 2019/8/9 19:08
     **/
    @RequestMapping(value = "selectAllPaperByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllPaperByPage(
            @RequestBody StatisticCondition condition
    ) {
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

        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }

    /**
     * 导出论文查询的结果
     *
     * @return void
     * @author zm
     * @date 2019/8/15 23:06
     **/
    @RequestMapping(value = "/exportPaperList", method = RequestMethod.GET)
    public void exportPaperList(
            @RequestParam("paperName") String paperName,
            @RequestParam("paperType") String paperType,
            @RequestParam("subject") String subject,
            @RequestParam("institute") String institute,
            @RequestParam("journalDivision") String journalDivision,
            @RequestParam("impactFactorMin") Double impactFactorMin,
            @RequestParam("impactFactorMax") Double impactFactorMax,
            @RequestParam("firstAuthorWorkId") String firstAuthorWorkId,
            @RequestParam("secondAuthorWorkId") String secondAuthorWorkId,
            @RequestParam("issn") String issn,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        StatisticCondition statisticCondition = new StatisticCondition();
        //1.设置待导出的论文List的状态为：已完成
        statisticCondition.setStatus("3");
        //2.reset一下论文的种类
        statisticCondition.setPaperType(dictService.getDictNameEnById(paperType));
        //3.设置其他的查询筛选条件
        statisticCondition.setPaperName(paperName);
        statisticCondition.setSubject(subject);
        statisticCondition.setInstitute(institute);
        statisticCondition.setJournalDivision(journalDivision);
        statisticCondition.setImpactFactorMin(impactFactorMin);
        statisticCondition.setImpactFactorMax(impactFactorMax);
        statisticCondition.setFirstAuthorWorkId(firstAuthorWorkId);
        statisticCondition.setSecondAuthorWorkId(secondAuthorWorkId);
        statisticCondition.setIssn(issn);
        if (!"NaN-NaN-NaN".equals(startDate)) {
            statisticCondition.setStartDate(sdf.parse(startDate));
        }
        if (!"NaN-NaN-NaN".equals(endDate)) {
            statisticCondition.setEndDate(sdf.parse(endDate));
        }
        //4.直接查询符合条件的paperList(statisticCondition中不含page，所以不会有分页的数目限制)
        List<DocPaper> paperList = docPaperService.selectAllPaperByPage(statisticCondition);

        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();

        HSSFSheet sheet = wb.createSheet("论文统计结果");
        String[] excelHeader = {
                "序号", "论文名称", "ISSN", "分区", "影响因子", "所属学院", "论文种类", "出版日期",
                "第一作者","第一作者中文名", "第一作者工号", "第一作者类型", "第二作者","第二作者中文名", "第二作者工号", "第二作者类型", "入藏号", "作者列表"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 300, 150, 150, 150, 200, 120, 200,
                160, 150,150, 120, 160,150, 150, 120, 250, 400
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

        for (int i = 0; i < paperList.size(); i++) {
            row = sheet.createRow(i + 1);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i);
            cell.setCellStyle(style);
            //第2列：论文名称
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getPaperName());
            cell.setCellStyle(style);
            //第3列：issn
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getIssn());
            cell.setCellStyle(style);
            //第4列：分区
            cell = row.createCell(cellNum++);
            if (paperList.get(i).getJournalDivision() == null || "".equals(paperList.get(i).getJournalDivision())){
                cell.setCellValue("暂无分区信息");
            }else{
                cell.setCellValue(paperList.get(i).getJournalDivision());
            }
            cell.setCellStyle(style);
            //第5列：影响因子
            cell = row.createCell(cellNum++);
            if (paperList.get(i).getJournalDivision() == null || "".equals(paperList.get(i).getJournalDivision())){
                cell.setCellValue("暂无影响因子");
            }else{
                cell.setCellValue(paperList.get(i).getImpactFactor());
            }
            cell.setCellStyle(style);
            //第6列：一级学科
            /*cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getSubject());
            cell.setCellStyle(style);*/
            //第7列：所属学院
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getDanweiCn());
            cell.setCellStyle(style);
            //第8列：论文种类
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getDocType());
            cell.setCellStyle(style);
            //第9列：出版日期
            cell = row.createCell(cellNum++);
            cell.setCellValue(sdf.format(paperList.get(i).getPublishDate()));
            cell.setCellStyle(style);
            //第10列：第一作者
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getFirstAuthorName());
            cell.setCellStyle(style);
            //第一作者中文名
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getFirstAuthorCname());
            cell.setCellStyle(style);
            //第11列：第一作者工号
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getFirstAuthorId());
            cell.setCellStyle(style);
            //第12列：第一作者类型
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getFirstAuthorType());
            cell.setCellStyle(style);
            //第13列：第二作者
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getSecondAuthorName());
            cell.setCellStyle(style);
            //第二作者中文名
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getSecondAuthorCname());
            cell.setCellStyle(style);
            //第14列：第二作者工号
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getSecondAuthorId());
            cell.setCellStyle(style);
            //第15列：第二作者类型
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getSecondAuthorType());
            cell.setCellStyle(style);
            //第16列：入藏号
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getStoreNum());
            cell.setCellStyle(style);
            //第17列：作者列表
            cell = row.createCell(cellNum++);
            cell.setCellValue(paperList.get(i).getAuthorList());
            cell.setCellStyle(style);
        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("论文统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }
}