package team.abc.ssm.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.sys.dao.FunctionDao;
import team.abc.ssm.modules.sys.entity.Function;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.entity.User;

import java.util.*;

@Service
public class FunctionService {

    @Autowired
    private FunctionDao functionDao;

    @Autowired
    private RoleService roleService;

    /**
     * 通过用户名获取该用户拥有的所有功能
     *
     * @param username 用户名
     * @return 拥有的功能集合(Set)(用于shiro的权限验证)
     */
    public Set<String> getFunctionSetByUsername(String username) {
        List<Function> functionList = getFunctionsByUsername(username);
        Set<String> result = new HashSet<>();
        for (Function function : functionList) {
            result.add(function.getCode());
        }
        return result;
    }

    /**
     * 通过用户名获取该用户拥有的所有功能
     *
     * @param username 用户名
     * @return 拥有的功能列表
     */
    private List<Function> getFunctionsByUsername(String username) {
        if (roleService.isAdmin(username)) // 具有特殊角色admin时直接获取所有权限
            return functionDao.selectAllEnabled();
        else
            return functionDao.selectByUsername(username);
    }

    /**
     * 通过用户名获取该用户的功能，并构建成一棵二级的菜单树
     *
     * @return 二级的菜单树
     */
    public List<Function> getFunctionTree(User user, Role role) {
        List<Function> categoryList = new ArrayList<>();
        List<Function> allList;
        if (user != null)
            allList = getFunctionsByUsername(user.getUsername());
        else if (role != null)
            allList = functionDao.selectByRole(role);
        else
            allList = functionDao.selectAll();
        // list中添加category
        for (Function category : allList) {
            if (category.getType() == 0) {
                categoryList.add(category);
            }
        }
        // category中添加function
        for (Function category : categoryList) {
            for (Function function : allList) {
                if (category.getId().equals(function.getParentId())) {
                    category.getFunctionList().add(function);
                }
            }
        }
        // 重新排序
        categoryList.sort(Comparator.comparingInt(Function::getIndex));
        for (Function category : categoryList) {
            category.getFunctionList().sort(Comparator.comparingInt(Function::getIndex));
        }
        return categoryList;
    }

    /**
     * 添加新的分类到末尾
     *
     * @param category 分类对象
     * @return 新添加的分类对象（已完善信息）
     */
    public Function addNewCategory(Function category) {
        category.setType(0);
        category.setEnable(false);
        category.setName("新分类");
        category.preInsert();
        int count = functionDao.insert(category);
        return count == 1 ? category : null;
    }

    /**
     * 再目标分类中添加子功能到末尾
     *
     * @param category 目标分类
     * @return 成功与否
     */
    public Function addNewFunction(Function category) {
        Function newFunction = new Function();
        newFunction.setType(1);
        newFunction.setEnable(false);
        newFunction.setName("新功能");
        newFunction.setParentId(category.getId());
        newFunction.setIndex(category.getFunctionList().size());
        newFunction.preInsert();
        int count = functionDao.insert(newFunction);
        return count == 1 ? newFunction : null;
    }

    /**
     * 删除指定id的function
     *
     * @param function 功能或分类
     * @return 成功与否
     */
    public boolean deleteById(Function function) {
        int count = functionDao.deleteById(function);
        return count == 1;
    }

    /**
     * 删除一个分类或功能
     * 实现：删除列表中第一个元素，后续元素更新index，index需在前端更新好
     */
    public boolean delete(List<Function> list) {
        boolean success1 = deleteById(list.get(0));
        list.remove(0);
        boolean success2 = updateIndex(list);
        return success1 && success2;
    }

    /**
     * 根据id批量更新对应function的index
     *
     * @param functionList 提供id和index
     * @return 成功与否
     */
    public boolean updateIndex(List<Function> functionList) {
        if (functionList.size() <= 0) return true;
        int count = functionDao.updateIndex(functionList);
        return count == functionList.size();
    }

    public boolean updateCategoryList(List<Function> categoryList) {
        List<Function> functionList = new ArrayList<>();
        for (Function c : categoryList) {
            functionList.add(c);
            for (Function f : c.getFunctionList()) {
                functionList.add(f);
            }
        }
        return updateList(functionList);
    }

    public boolean updateList(List<Function> functionList) {
        if (functionList.size() <= 0) return true;
        int count = functionDao.updateIndex(functionList);
        return count == functionList.size();
    }

    /**
     * 根据id更新对应的function
     *
     * @param function 存储id和需要更新的数据
     * @return
     */
    public boolean update(Function function) {
        function.preUpdate();
        int count = functionDao.update(function);
        return count == 1;
    }
}
