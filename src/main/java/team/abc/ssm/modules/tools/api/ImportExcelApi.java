package team.abc.ssm.modules.tools.api;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.utils.excel.ExcelColumn;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tools.service.DatabaseService;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("api/tools/importExcel")
public class ImportExcelApi extends BaseApi {

    @Autowired
    private DatabaseService databaseService;

    @RequestMapping(value = "getColumnsInTableAndExcel", method = RequestMethod.POST)
    @ResponseBody
    public Object getColumnsInTableAndExcel(
            @RequestParam("tableName") String tableName,
            @RequestParam("excelFileName") String excelFileName,
            HttpServletRequest request) {
        File dir = new File(request.getSession().getServletContext().getRealPath("WEB-INF/temp"));
        File excel = new File(dir, excelFileName);

        InputStream is = null;
        XSSFWorkbook workbook = null;
        try {
            is = new FileInputStream(excel.getPath());
            workbook = new XSSFWorkbook(is);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 只取第一个sheet
        XSSFSheet sheet = workbook.getSheetAt(0);
        XSSFRow firstRow = sheet.getRow(0);

//        int rowSize = firstRow.getLastCellNum();
//        for (int rowIndex = 1; rowIndex < sheet.getLastRowNum(); rowIndex++) {
//            XSSFRow row = sheet.getRow(rowIndex);
//        }

        List<ExcelColumn> columnList = new ArrayList<>();
        for (int col = 0; col < firstRow.getLastCellNum(); col++) {
            XSSFCell cell = firstRow.getCell(col);
            if (cell == null)
                continue;
//            ExcelColumn column =
//            columns.add(cell.getStringCellValue());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }
}
