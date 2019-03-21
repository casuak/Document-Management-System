package team.abc.ssm.modules.tools.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.tools.dao.DatabaseDao;

import java.util.List;

@Service
public class DatabaseService {

    @Autowired
    private DatabaseDao databaseDao;

    public List<String> showTables(){
        return databaseDao.showTables();
    }
}
