UI-Automation-Testing
=====================

It is a UI automation testing framework named "WAT"

安装方法：

1.cd到存放gem包的目录，用命令gem install WAT-1.8.gem -l 安装（前提条件是watir>3.0）

使用方法：

1.安装完后，用wat -h去查看命令

2.创建workspace. cd到你要创建workspace的目录，用命令wat -cw test  会创建一个test的文件夹，该文件夹就是workspace

3.创建project. cd到workspace目录里，用命令wat -cp Demo 在testcase 文件夹下会创建一个Demo的project

4.在workspace里，可以用命令wat list查看所有的project,用命令wat all运行所有的project,用命令wat all -y运行在config/run.yaml里配置的所有的project

5.还有其它的运行单个project,test 等的命令，可用wat -h查看

WAT的使用方法：

1.当创建完project "Demo"后，在testcase文件夹下会创建一个Demo的文件夹，Demo文件夹下会出现如下的文件：conf.yaml,Demo.rb,Demo.yaml,ExpectedData.yaml,TestData.yaml

2.conf.yaml的作用

    conf.yaml创建时为空，
    conf.yaml文件是对config/conf.yaml文件的扩展，在conf.yaml里可以自定义配置选项，如果conf.yaml与config/conf.yaml的配置项相同，config/conf.yaml里的配置项则会被conf.yaml里的配置项覆盖。
    在测试方法里，即Demo.rb文件里的测试方法里，调用conf.yaml与config/conf.yaml里的配置项的方法为：ConfigData("配置项名称")。

3.Demo.yaml的作用

    Demo.yaml是存放页面元素对象的文件。
    Demo.yaml文件在最初始时不为空，显示了存放页面元素对象的两种方式。
    第一种方式中，type是必填项.parent结点,如果有parent，则需加上，如没有，则不加、。比如@ie.div(:class,"test").div(:index,1),示例为：
    test1:
      type: div
      class: test
    test2:
      type: div
      index: 1
      parent: test1
    test1没有parent，所以不必要加上该结点，test2有parent "test1",所以需要加上parent,value为test1。
    第二种方式中，写法为：
    test2: div(:class,"test").div(:index,1)
    我们在项目中，其实第二种方式用的比较多。
    第三种方式，在Demo.yaml文件中没有演示出来，用法是：（第三种方式配合第二种方式，这样效果会更好）
    test1: div(:class,"test")
    test2: %test1%.div(:index,1)
    在测试方法里，即Demo.rb文件里的测试方法里，调用Demo.yaml的页面元素对象的方法为：AutoTest("test1"),AutoTest("test2").

4.TestData.yaml的作用

    TestData.yaml是存放测试数据的文件，格式一定要严格按照文件中已定义好的格式
    由于该框架是数据驱动的模式，数据驱动的概念是指脚本或测试方法根据配置的数据的条数来循环运行，所以除common结点外，其它的结点是脚本中测试方法的名称，比如在Demo.rb文件中有个test_Demo方法，所以在TestData.yaml的配置：
    - test_Demo:
        description: test for 123
        inputValue: 123
    - test_Demo:
        description: test for 234
        inputValue: 234
    则test_Demo方法会运行两次，在脚本中用inputValue的值时，第一次是123，第二次为234.
    如果在TestData.yaml里的结点与Demo.rb文件中的测试方法名不一致，则会没有测试方法被运行。
    TestData.yaml中的common结点，是配置的测试方法中的数据的公共结点，common结点里的数据，在配置的测试方法中都可以被使用，如果测试方法中与common中存在相同的数据，则common结点中的数据会被覆盖。比如：test_Demo中的description的value值就会覆盖common中的description的value值。TestData.yaml文件中必须存在三个数据结点：private，smoking，description。否则会报错。
    private，smoking是两种运行模式，在config/conf.yaml中RunTimeModule的值如果为private,则会运行private的值为y的测试方法，比如：
    - test_Demo:
        private: y
        description: test for 123
        inputValue: 123
    - test_Demo:
        private: n
        description: test for 123
        inputValue: 123
    则test_Demo只会private被标记为y的一次，标记为n的则不会被运行
    description的数据则会被显示在报告中。
    在testcase文件夹下面有个GlobalData.yaml，也是存放测试数据的，里面的数据会被用到所有的project中，里面的数据如果与project中TestData.yaml的测试数据一样时，则会被project中TestData.yaml的测试数据覆盖。比如在一个系统中，可能都会有用户名与密码，则放在GlobalData.yaml中即可，存放数据的格式为:
    loginname: test1
    password: test
    总结：如果GlobalData.yaml存在loginname: test1，在ExpectedData.yaml的common结点下存在loginname: test2，在test_Demo下存在loginname: test3,则在脚本中调用loginname时，值为test3.
    测试数据在test_Demo中的调用方式为：TestData("loginname")

5.ExpectedData.yaml的作用

    ExpectedData.yaml是存放期望值的文件
    ExpectedData.yaml存放数据的格式为：
    hello: 123
    world: 234
    ExpectedData.yaml中的数据在test_Demo中的调用方式为：ExpectData("hello")

6.Demo.rb的作用

    Demo.rb是存放测试方法的地方
    Demo.rb在被生成时，就已经生成好了类与所需要require的文件，格式都已定义好，只需要填写好测试方法即可，当然类名与测试方法名也可以更改，但测试方法名如果更改了，则需记得在TestData.yaml中配置上相应测试方法名。
    setUp方法是指每个测试方法运行前必须会运行的方法，getWebApplication是指创建一个浏览器的对象，调用getWebApplication后会产生一个框架的内置对象@b(类似于watir中@b=Watir::IE.new)。
    tearDown是指每个测试方法运行后必须会运行的方法。@b.close指关闭浏览器，这是watir中的API。
    test_Demo是测试方法，测试方法必须以test开头，否则会不被当成测试方法，这样即使在TestData.yaml中配置了，也不会被运行。
    test_Demo中被注释的项都是在test_Demo中可以被使用的方法
    AutoTest("") 调用Demo.yaml中页面元素对象
    TestData("") 调用TestData.yaml中的测试数据
    ExpectData("") 调用ExpectedData.yaml中的期望值数据
    ConfigData("") 调用conf.yaml中的配置数据
    LoadObject("") 在脚本中加载其它的页面元素对象文件，其文件只能是yaml文件，格式与Demo.yaml文件格式一样，加载的页面元素对象如果与Demo.yaml中一致时，则会覆盖Demo.yaml文件中的数据。此时工作路径在testcase\Demo下，如果要加载testcase\test1.yaml中的数据，则为LoadObject("../test1.yaml")
    LoadTestData("") 在脚本中加载其它的测试数据文件，其文件只能是yaml文件，格式为：
    hello: 123
    加载的测试数据如果与TestData.yaml中 一致时，则会覆盖TestData.yaml文件中的数据。此时工作路径在testcase\Demo下，如果要加载testcase\test2.yaml中的数据，则为LoadTestData("../test2.yaml")
    LoadExpectData("") 在脚本中加载其它的期望值数据文件，其文件只能是yaml文件，格式与ExpectedData.yaml文件格式一样，加载的期望值数据如果与ExpectedData.yaml中 一致时，则会覆盖ExpectedData.yaml文件中的数据。此时工作路径在testcase\Demo下，如果要加载testcase\test3.yaml中的数据，则为LoadExpectData("../test3.yaml")
    TransferData("") 在测试方法运行完成后，会在lib/transfer.yaml(如果是1.8版本的，则在config/transfer.yaml)中保存该测试方法的返回值，这样在其它的project中可以调用：
    TransferData("test_Demo")会返回测试方法test_Demo最后一次运行的返回值（TransferData("")还不太完善，处理方式还没有想清楚，所以大家慎用）
    assert_string("","","")，assert_array("","","")，assert_hash("","","")，assert_true(true,"")，assert_false(false,"") 这是五个断方方法，这五个方法中的最后一个参数可以为空，也可以不写，其数据为自已添加，会反应在测试报告中，比如：assert_string("123","123","should be 123")
    l "" 是指在测试方法中添加log，其会反应在测试报告中，比如 l "this is the first step","this is the first step"这一句话会显示在测试报告中。

7.大家在使用的过程中，如果有任何疑问或建议，可直接联系我（QQ群号：254285583），我会第一时间给出答案。希望大家试用愉快。共同学习，共同进步。

 

WAT示例

准备条件：

1.创建project "Demo"后，在testcase文件夹下会创建一个Demo的文件夹，Demo文件夹下会出现如下的文件：conf.yaml,Demo.rb,Demo.yaml,ExpectedData.yaml,TestData.yaml

2.我们创建一个登录百度，并输入值"Hello World"，搜索，并在搜索出来的结果页面的输入框的值是否是"Hello World"，最后关闭浏览器的示例。

开始写用例：

1.写Demo.yaml

input: text_field(:id,"kw")
button: button(:id,"su")

2.写TestData.yaml

- common:
    private: y
    smoking: y
    description: ""
- test_Demo:
    description: test for baidu search
    inputValue: Hello World
    url: "http://baidu.com"

3.写ExpectedData.yaml

inputValue: Hello World

4.写Demo.rb

class Demo < TestKlass
 
  def setUp    
    getWebApplication
  end
 
  def tearDown    
    @b.close
  end
 
  def test_Demo
    #AutoTest("")
    #LoadObject("")
    #TestData("")
    #ExpectData("")
    #LoadTestData("")
    #LoadExpectData("")
    #TransferData("")
    #ConfigData("")
    #assert_string("","","")
    #assert_array("","","")
    #assert_hash("","","")
    #assert_true(true,"")
    #assert_false(false,"")    
    #l ""
    l "this is a test for demo"
    @b.goto TestData("url")
    @b.wait
    AutoTest("input").set TestData("inputValue")    
    AutoTest("button").click    
    assert_string(AutoTest("input").text,ExpectData("inputValue"),"Input value should be correct")
  end
    
end 

5.按上面的步骤写完后，直接运行，在report/Demo文件夹下面，打开Demo.html，就可以看到对应的报告。

6.开始体验吧！
