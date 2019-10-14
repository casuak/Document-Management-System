package team.abc.ssm.modules.author.api;

import net.sf.json.JSONArray;
import org.apache.http.client.utils.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.doc.service.PatentService;
import team.abc.ssm.modules.sys.service.FunctionService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Controller
@RequestMapping(value = "/author")
public class AuthorApi extends BaseApi {

    private static final Logger LOG = LoggerFactory.getLogger(AuthorApi.class);

    @Autowired
    private AuthorService authorService;

    @Autowired
    private PaperSearchService paperSearchService;

    @Autowired
    private PatentService patentService;

    @Autowired
    private FunctionService functionService;

    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Description 跳转到作者查询页面
     * @author zm
     * @date 18:10 2019/5/8
     */
    @RequestMapping(value = "goAuthorSearch",method = RequestMethod.GET)
    public ModelAndView goAuthorSearch (){
        ModelAndView modelAndView = new ModelAndView();

        modelAndView.setViewName("functions/author/authorSearch");

        List<Map<String, String>> paperType = paperSearchService.getPaperType();

        List<String> orgList = functionService.getOrgList();

        List<String> subjectList = authorService.getSubList();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));

        return modelAndView;
    }

    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Description 跳转到作者详情页面
     * @author zm
     * @date 15:16 2019/4/23
     */
    @RequestMapping(value = "goAuthorDetail", method = RequestMethod.GET)
    public ModelAndView goAuthorDetail(
                    @RequestParam("authorId") String authorId,
            ModelAndView modelAndView
    ) {
        modelAndView.setViewName("functions/author/authorInfo");
        Author authorNow = authorService.getAuthor(authorId);
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }

    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Description 跳转到作者统计页面
     * @author wh
     * @date 15:16 2019/9/9
     */
    @RequestMapping(value = "goAuthorStatistics", method = RequestMethod.GET)
    public ModelAndView goAuthorStatistics(

    ) {
        ModelAndView modelAndView = new ModelAndView();

        modelAndView.setViewName("functions/author/authorStatistics");

        List<Map<String, String>> paperType = paperSearchService.getPaperType();

        List<String> orgList = functionService.getOrgList();

        List<String> subjectList = authorService.getSubList();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));
        return modelAndView;
    }

    /**
     * @return java.lang.Object
     * @author wh 按页查询作者统计
     * @date 2019/9/9
     */
    @RequestMapping(value = "/getAuthorStatisticsByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorStatisticsByPage(
            @RequestBody AuthorStatistics authorStatistics
            ) {
        Page<AuthorStatistics> data = new Page<>();
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsList(authorStatistics);
        //设置返回的authorList信息
        data.setResultList(authorList);
        int authorNum = authorService.getAuthorStatisticsNum(authorStatistics);
        //设置查询出的作者总数
        data.setTotal(authorNum);
        return retMsg.Set(MsgType.SUCCESS, data, "getAuthorListByPage-ok");
    }
    //按照一级学科统计
    @RequestMapping(value = "/getAuthorStatisticsByMajor", method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorStatisticsByMajor(
            @RequestBody AuthorStatistics authorStatistics
    ) {
        Page<AuthorStatistics> data = new Page<>();
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsByMajor(authorStatistics);
        //设置返回的authorList信息
        data.setResultList(authorList);
        //设置查询出的作者总数
        data.setTotal(authorService.getAuthorStatisticsCountByMajor(authorStatistics));
        return retMsg.Set(MsgType.SUCCESS, data, "getAuthorListByMajor-ok");
    }
    //按照学院统计
    @RequestMapping(value = "/getAuthorStatisticsBySchool", method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorStatisticsBySchool(
            @RequestBody AuthorStatistics authorStatistics
    ) {
        Page<AuthorStatistics> data = new Page<>();
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsBySchool(authorStatistics);
        //设置返回的authorList信息
        data.setResultList(authorList);
        //设置查询出的作者总数
        data.setTotal(authorService.getAuthorStatisticsCountBySchool(authorStatistics));
        return retMsg.Set(MsgType.SUCCESS, data, "getAuthorListBySchool-ok");
    }

    @RequestMapping(value = "/exportStatisticsList", method = RequestMethod.GET)
    public void exportPaperList(
            @RequestParam("realName") String realName,
            @RequestParam("workId") String workId,
            @RequestParam("school") String school,
            @RequestParam("major") String major,
            @RequestParam("type") String type,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


        if(school .equals("undefined")) school="";
        if(major.equals("undefined")) major="";
        AuthorStatistics authorStatistics = new AuthorStatistics();
        authorStatistics.setRealName(realName);
        authorStatistics.setWorkId(workId);
        authorStatistics.setSchool(school);
        authorStatistics.setMajor(major);
        authorStatistics.setType(type);
        Page<AuthorStatistics> data = new Page<>();
        data.setPageStart(0);
        data.setPageIndex(1);
        data.setPageSize(99999);
        authorStatistics.setPage(data);

        //4.直接查询符合条件的List
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsList(authorStatistics);
        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("导师统计结果");
        String[] excelHeader = {
                "序号", "管理所在学院", "姓名", "学科一", "工号",
                "合计", "Q1", "Q2", "Q3", "Q4","合计", "Q1", "Q2", "Q3", "Q4",
                "导师", "学生",
                "合计","国家重点研发计划","NSFC重大研发计划","国家重大科研仪器研制项目","NSFC科学中心项目",
                "NSFC重大项目","NSFC重点项目","NSFC面上项目","NSFC青年项目","NSSFC重大项目","NSSFC重点项目","NSSFC一般项目","NSSFC青年项目"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 200, 130, 200, 150,
               50,50,50,50,50,  50,50,50,50,50,
                50,50,
                50,150,150,150,150,
                150,150,150,150,150,150,150,150
        };


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
        HSSFRow row2 = sheet.createRow((int) 0);
        for (int i = 0; i < 5; i++) {
            HSSFCell cell = row2.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }


        String[] excelHeader2 = {"SCI/SSCI发发文量","专利发明数","基金项目数"};
        HSSFCell cell2 = row2.createCell(5);
        cell2.setCellValue(excelHeader2[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(15);
        cell2.setCellValue(excelHeader2[1]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(17);
        cell2.setCellValue(excelHeader2[2]);
        cell2.setCellStyle(style1);

        row2 = sheet.createRow((int) 1);
        String[] excelHeader3 = {"导师","学生"};
        cell2=row2.createCell(5);
        cell2.setCellValue(excelHeader3[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(10);
        cell2.setCellValue(excelHeader3[1]);
        cell2.setCellStyle(style1);




        HSSFRow row = sheet.createRow((int) 2);
        for (int i = 5; i < excelHeader.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }

        sheet.addMergedRegion(new CellRangeAddress(0, 2, 0, 0));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 2, 2));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 3, 3));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 4, 4));

        sheet.addMergedRegion(new CellRangeAddress(0, 0, 5, 14));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 5, 9));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 10, 14));


        sheet.addMergedRegion(new CellRangeAddress(0, 1, 15, 16));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 17, 29));



        row = sheet.createRow((int) 3);
        for (int i = 0; i < authorList.size(); i++) {
            row = sheet.createRow(i + 3);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i+1);
            cell.setCellStyle(style);
            //第2列：管理所在学院
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getSchool());
            cell.setCellStyle(style);
            //第3列 ：姓名
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getRealName());
            cell.setCellStyle(style);
            //第4列：学科一
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getMajor());
            cell.setCellStyle(style);
            //第5列:工号
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getWorkId());
            cell.setCellStyle(style);
            //第6列:导师论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPaperSum());
            cell.setCellStyle(style);
            //第7列:导师Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ1());
            cell.setCellStyle(style);

            //第8列:导师Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ2());
            cell.setCellStyle(style);
            //第9列:导师Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ3());
            cell.setCellStyle(style);
            //第10列:导师Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ4());
            cell.setCellStyle(style);
            //第11列：学生论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPaperSum());
            cell.setCellStyle(style);
            //第12列：学生Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ1());
            cell.setCellStyle(style);
            //第13列：学生Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ2());
            cell.setCellStyle(style);
            //第13列：学生Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ3());
            cell.setCellStyle(style);
            //第14列：学生Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ4());
            cell.setCellStyle(style);
            //第15列：导师专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPatent());
            cell.setCellStyle(style);
            //第16列：学生专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPatent());
            cell.setCellStyle(style);
            //第17列：基金合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getFundSum());
            cell.setCellStyle(style);



            //第18列：国家重点研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationFocus());
            cell.setCellStyle(style);
            //第19列：NSFC重大研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDYF());
            cell.setCellStyle(style);
            //第20列：国家重大科研仪器研制项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationInstrument());
            cell.setCellStyle(style);
            //第21列：NSFC科学中心项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcKXZX());
            cell.setCellStyle(style);
            //第22列：NSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDAXM());
            cell.setCellStyle(style);
            //第23列：NSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDIANXM());
            cell.setCellStyle(style);
            //第24列：NSFC面上项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcMSXM());
            cell.setCellStyle(style);
            //第25列：NSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcQNXM());
            cell.setCellStyle(style);
            //第26列：NSSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDAXM());
            cell.setCellStyle(style);
            //第27列：NSSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDIANXM());
            cell.setCellStyle(style);

            //第28列：NSSFC一般项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcYBXM());
            cell.setCellStyle(style);

            //第29列：NSSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcQNXM());
            cell.setCellStyle(style);


        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("导师统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }

    @RequestMapping(value = "/exportStatisticsMajorList", method = RequestMethod.GET)
    public void exportPaperMajorList(
            @RequestParam("major") String major,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


        if(major.equals("undefined")) major="";
        AuthorStatistics authorStatistics = new AuthorStatistics();
        authorStatistics.setMajor(major);
        Page<AuthorStatistics> data = new Page<>();
        data.setPageStart(0);
        data.setPageIndex(1);
        data.setPageSize(99999);
        authorStatistics.setPage(data);

        //4.直接查询符合条件的List
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsByMajor(authorStatistics);
        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("学科统计结果");
        String[] excelHeader = {
                "序号", "学科","导师人数",
                "合计", "人均","Q1", "Q2", "Q3", "Q4","合计","人均","Q1", "Q2", "Q3", "Q4",
                "合计","人均","合计","人均",
                "合计","国家重点研发计划","NSFC重大研发计划","国家重大科研仪器研制项目","NSFC科学中心项目","国际（地区）合作研究与交流项目",
                "NSFC重大项目","NSFC重点项目","NSFC面上项目","NSFC青年项目","NSSFC重大项目","NSSFC重点项目","NSSFC一般项目","NSSFC青年项目"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 200, 100,
                50,50,50,50,50,50,  50,50,50,50,50,50,
                50,50,50,50,
                50,150,150,150,150,200,
                150,150,150,150,150,150,150,150
        };


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
        HSSFRow row2 = sheet.createRow((int) 0);
        for (int i = 0; i < 3; i++) {
            HSSFCell cell = row2.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }


        String[] excelHeader2 = {"SCI/SSCI发发文量","专利发明数","基金项目数"};
        HSSFCell cell2 = row2.createCell(3);
        cell2.setCellValue(excelHeader2[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(15);
        cell2.setCellValue(excelHeader2[1]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(19);
        cell2.setCellValue(excelHeader2[2]);
        cell2.setCellStyle(style1);

        row2 = sheet.createRow((int) 1);
        String[] excelHeader3 = {"导师","学生"};
        cell2=row2.createCell(3);
        cell2.setCellValue(excelHeader3[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(9);
        cell2.setCellValue(excelHeader3[1]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(15);
        cell2.setCellValue(excelHeader3[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(17);
        cell2.setCellValue(excelHeader3[1]);
        cell2.setCellStyle(style1);



        HSSFRow row = sheet.createRow((int) 2);
        for (int i = 3; i < excelHeader.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }

        sheet.addMergedRegion(new CellRangeAddress(0, 2, 0, 0));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 2, 2));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 19, 32));

        sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 14));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 3, 8));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 9, 14));


        sheet.addMergedRegion(new CellRangeAddress(0, 0, 15, 18));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 15, 16));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 17, 18));


        row = sheet.createRow((int) 3);
        for (int i = 0; i < authorList.size(); i++) {
            row = sheet.createRow(i + 3);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i+1);
            cell.setCellStyle(style);

            //第2列：学科一
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getMajor());
            cell.setCellStyle(style);
            //第3列:导师数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTotalNum());
            cell.setCellStyle(style);
            //第4列:导师论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPaperSum());
            cell.setCellStyle(style);
            //第5列:导师论文人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorAverage());
            cell.setCellStyle(style);
            //第6列:导师Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ1());
            cell.setCellStyle(style);

            //第7列:导师Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ2());
            cell.setCellStyle(style);
            //第8列:导师Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ3());
            cell.setCellStyle(style);
            //第9列:导师Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ4());
            cell.setCellStyle(style);
            //第10列：学生论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPaperSum());
            cell.setCellStyle(style);
            //第10列:学生论文人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuAverage());
            cell.setCellStyle(style);
            //第12列：学生Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ1());
            cell.setCellStyle(style);
            //第13列：学生Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ2());
            cell.setCellStyle(style);
            //第13列：学生Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ3());
            cell.setCellStyle(style);
            //第14列：学生Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ4());
            cell.setCellStyle(style);
            //第15列：导师专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPatent());
            cell.setCellStyle(style);
            //第16列:导师专利人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPatentAverage());
            cell.setCellStyle(style);
            //第17列：学生专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPatent());
            cell.setCellStyle(style);
            //第18列:学生专利人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPatentAverage());
            cell.setCellStyle(style);
            //第19列：基金合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getFundSum());
            cell.setCellStyle(style);



            //第20列：国家重点研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationFocus());
            cell.setCellStyle(style);
            //第21列：NSFC重大研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDYF());
            cell.setCellStyle(style);
            //第22列：国家重大科研仪器研制项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationInstrument());
            cell.setCellStyle(style);
            //第23列：NSFC科学中心项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcKXZX());
            cell.setCellStyle(style);
            //第24列：NSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDAXM());
            cell.setCellStyle(style);
            //第25列：国际（地区）合作研究与交流项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationResearch());
            cell.setCellStyle(style);
            //第26列：NSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDIANXM());
            cell.setCellStyle(style);
            //第27列：NSFC面上项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcMSXM());
            cell.setCellStyle(style);
            //第28列：NSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcQNXM());
            cell.setCellStyle(style);
            //第29列：NSSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDAXM());
            cell.setCellStyle(style);
            //第30列：NSSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDIANXM());
            cell.setCellStyle(style);

            //第31列：NSSFC一般项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcYBXM());
            cell.setCellStyle(style);

            //第32列：NSSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcQNXM());
            cell.setCellStyle(style);


        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("学科统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }

    @RequestMapping(value = "/exportStatisticsSchoolList", method = RequestMethod.GET)
    public void exportPaperSchoolList(
            @RequestParam("school") String school,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse
    ) throws IOException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


        if(school.equals("undefined")) school="";
        AuthorStatistics authorStatistics = new AuthorStatistics();
        authorStatistics.setSchool(school);
        Page<AuthorStatistics> data = new Page<>();
        data.setPageStart(0);
        data.setPageIndex(1);
        data.setPageSize(99999);
        authorStatistics.setPage(data);

        //4.直接查询符合条件的List
        List<AuthorStatistics> authorList = authorService.getAuthorStatisticsBySchool(authorStatistics);
        //5.导出
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("学科统计结果");
        String[] excelHeader = {
                "序号", "学院","导师人数",
                "合计", "人均","Q1", "Q2", "Q3", "Q4","合计","人均","Q1", "Q2", "Q3", "Q4",
                "合计","人均","合计","人均",
                "合计","国家重点研发计划","NSFC重大研发计划","国家重大科研仪器研制项目","NSFC科学中心项目","国际（地区）合作研究与交流项目",
                "NSFC重大项目","NSFC重点项目","NSFC面上项目","NSFC青年项目","NSSFC重大项目","NSSFC重点项目","NSSFC一般项目","NSSFC青年项目"
        };
        // 单元格列宽
        int[] excelHeaderWidth = {
                40, 200, 100,
                50,50,50,50,50,50,  50,50,50,50,50,50,
                50,50,50,50,
                50,150,150,150,150,200,
                150,150,150,150,150,150,150,150
        };


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
        HSSFRow row2 = sheet.createRow((int) 0);
        for (int i = 0; i < 3; i++) {
            HSSFCell cell = row2.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }


        String[] excelHeader2 = {"SCI/SSCI发发文量","专利发明数","基金项目数"};
        HSSFCell cell2 = row2.createCell(3);
        cell2.setCellValue(excelHeader2[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(15);
        cell2.setCellValue(excelHeader2[1]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(19);
        cell2.setCellValue(excelHeader2[2]);
        cell2.setCellStyle(style1);

        row2 = sheet.createRow((int) 1);
        String[] excelHeader3 = {"导师","学生"};
        cell2=row2.createCell(3);
        cell2.setCellValue(excelHeader3[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(9);
        cell2.setCellValue(excelHeader3[1]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(15);
        cell2.setCellValue(excelHeader3[0]);
        cell2.setCellStyle(style1);

        cell2=row2.createCell(17);
        cell2.setCellValue(excelHeader3[1]);
        cell2.setCellStyle(style1);



        HSSFRow row = sheet.createRow((int) 2);
        for (int i = 3; i < excelHeader.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellValue(excelHeader[i]);
            cell.setCellStyle(style1);
        }

        sheet.addMergedRegion(new CellRangeAddress(0, 2, 0, 0));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(0, 2, 2, 2));
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 19, 32));

        sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 14));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 3, 8));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 9, 14));


        sheet.addMergedRegion(new CellRangeAddress(0, 0, 15, 18));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 15, 16));
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 17, 18));


        row = sheet.createRow((int) 3);
        for (int i = 0; i < authorList.size(); i++) {
            row = sheet.createRow(i + 3);
            int cellNum = 0;
            //第一列存的是序号
            HSSFCell cell = row.createCell(cellNum++);
            cell.setCellValue(i+1);
            cell.setCellStyle(style);

            //第2列：学院
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getSchool());
            cell.setCellStyle(style);
            //第3列:导师数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTotalNum());
            cell.setCellStyle(style);
            //第4列:导师论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPaperSum());
            cell.setCellStyle(style);
            //第5列:导师论文人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorAverage());
            cell.setCellStyle(style);
            //第6列:导师Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ1());
            cell.setCellStyle(style);

            //第7列:导师Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ2());
            cell.setCellStyle(style);
            //第8列:导师Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ3());
            cell.setCellStyle(style);
            //第9列:导师Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorQ4());
            cell.setCellStyle(style);
            //第10列：学生论文数量合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPaperSum());
            cell.setCellStyle(style);
            //第10列:学生论文人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuAverage());
            cell.setCellStyle(style);
            //第12列：学生Q1论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ1());
            cell.setCellStyle(style);
            //第13列：学生Q2论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ2());
            cell.setCellStyle(style);
            //第13列：学生Q3论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ3());
            cell.setCellStyle(style);
            //第14列：学生Q4论文数量
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuQ4());
            cell.setCellStyle(style);
            //第15列：导师专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPatent());
            cell.setCellStyle(style);
            //第16列:导师专利人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getTutorPatentAverage());
            cell.setCellStyle(style);
            //第17列：学生专利总计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPatent());
            cell.setCellStyle(style);
            //第18列:学生专利人均
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getStuPatentAverage());
            cell.setCellStyle(style);
            //第19列：基金合计
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getFundSum());
            cell.setCellStyle(style);



            //第20列：国家重点研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationFocus());
            cell.setCellStyle(style);
            //第21列：NSFC重大研发计划
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDYF());
            cell.setCellStyle(style);
            //第22列：国家重大科研仪器研制项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationInstrument());
            cell.setCellStyle(style);
            //第23列：NSFC科学中心项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcKXZX());
            cell.setCellStyle(style);
            //第24列：NSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDAXM());
            cell.setCellStyle(style);
            //第25列：国际（地区）合作研究与交流项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNationResearch());
            cell.setCellStyle(style);
            //第26列：NSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcZDIANXM());
            cell.setCellStyle(style);
            //第27列：NSFC面上项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcMSXM());
            cell.setCellStyle(style);
            //第28列：NSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNsfcQNXM());
            cell.setCellStyle(style);
            //第29列：NSSFC重大项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDAXM());
            cell.setCellStyle(style);
            //第30列：NSSFC重点项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcZDIANXM());
            cell.setCellStyle(style);

            //第31列：NSSFC一般项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcYBXM());
            cell.setCellStyle(style);

            //第32列：NSSFC青年项目
            cell = row.createCell(cellNum++);
            cell.setCellValue(authorList.get(i).getNssfcQNXM());
            cell.setCellStyle(style);


        }

        httpServletResponse.setContentType("application/vnd.ms-excel");
        //注意此处文件名称如果想使用中文的话，要转码new String( "中文".getBytes( "gb2312" ), "ISO8859-1" )
        httpServletResponse.setHeader("Content-disposition",
                "attachment;filename=" + new String("学院统计结果".getBytes("gb2312"), "ISO8859-1")
                        + DateUtils.formatDate(new Date(), "yyyy-MM-dd") + ".xls");
        OutputStream ouputStream = httpServletResponse.getOutputStream();
        wb.write(ouputStream);
        ouputStream.flush();
        ouputStream.close();
    }



    /**
     * @return java.lang.Object
     * @Description 加载作者详情页面的内容
     * @author zm
     * @date 14:40 2019/4/23
     */
    @RequestMapping(value = "getAuthorDetail", method = RequestMethod.POST)
    public Object getAuthorDetail(
            @RequestParam("authorId") String authorId,
            @RequestParam("paperPage") Page<Paper> paperPage,
            @RequestParam("patentPage") Page<Patent> patentPage
    ) {
        Author authorNow = authorService.getAuthor(authorId);
        Page<Author> authorPage = new Page<>();
        authorNow.setPage(authorPage);

        /*获取集合*/
        List<Paper> myPaperList = paperSearchService.getMyPaperByPage(authorNow);
        List<Patent> myPatentList = patentService.getMyPatentByPage(authorNow);

        /*设置分页中的数据内容*/
        paperPage.setResultList(myPaperList);
        patentPage.setResultList(myPatentList);

        /*设置数目*/
        paperPage.setTotal(paperSearchService.getMyPaperAmount(authorId));
        patentPage.setTotal(patentService.getMyPatentAmount(authorId));
        HashMap<String, Page<?>> pageMap = new HashMap<>();
        pageMap.put("paper", paperPage);
        pageMap.put("patent", patentPage);

        //return "functions/author/authorIWnfo";
        return retMsg.Set(MsgType.SUCCESS, pageMap);
    }

    /**
     * @return java.lang.Object
     * @author zm 按页查询作者
     * @date 2019/4/22
     */
    @RequestMapping(value = "/getAuthorListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorListByPage(
            @RequestBody Author author
    ) {
        Page<Author> data = new Page<>();
        List<Author> authorList = authorService.getAuthorList(author);
        //设置返回的authorList信息
        data.setResultList(authorList);
        int authorNum = authorService.getAuthorListCount(author);
        //设置查询出的作者总数
        data.setTotal(authorNum);
        return retMsg.Set(MsgType.SUCCESS, data, "getAuthorListByPage-ok");
    }
}
