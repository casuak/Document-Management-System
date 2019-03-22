package team.abc.ssm.modules.tools.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.tools.service.DatabaseService;

import java.util.List;

@Controller
@RequestMapping("api/tools/database")
public class DatabaseApi extends BaseApi {

    @Autowired
    private DatabaseService databaseService;

    @RequestMapping(value = "showTables", method = RequestMethod.POST)
    @ResponseBody
    public Object showTables() {
        List<String> tableList = databaseService.showTables();
        return retMsg.Set(MsgType.SUCCESS, tableList);
    }

    @RequestMapping(value = "selectColumnsInTable", method = RequestMethod.POST)
    @ResponseBody
    public Object selectColumnsInTable(@RequestParam("tableName") String tableName){
        return retMsg.Set(MsgType.SUCCESS, databaseService.selectColumnsInTable(tableName));
    }
}
