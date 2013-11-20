<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.crawler.StockDO"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.util.*"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<body>

<%  
URL oracle = new URL("http://finance.yahoo.com/lookup/stocks;_ylt=AhW41_lOscQ5gL0KaBzztULXVax_;_ylu=X3oDMTFiM3RzMzF1BHBvcwMyBHNlYwN5ZmlTeW1ib2xMb29rdXBSZXN1bHRzBHNsawNzdG9ja3M-?s=%5Ea&t=S&m=ALL&r=");
BufferedReader in = new BufferedReader(
new InputStreamReader(oracle.openStream()));

String inputLine;
String page1 = "";
while ((inputLine = in.readLine()) != null)
{
	page1= page1+"\n"+inputLine;
}
String stocks = page1.substring(page1.indexOf("Exchange</a></th></tr></thead><tbody>")+37,page1.indexOf("</tbody></table></div><div id=\"pagination\">"));
in.close();
List<StockDO> stockDOList = new ArrayList<StockDO>();
String[] companies = stocks.split("</tr>");
HashMap<String,String> map = new HashMap<String,String>();

for(int i=0;i<companies.length;i++){
//	System.out.println(companies[i]);
	StockDO stockDO = new StockDO();
	String url = companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).substring(companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).indexOf("=\"")+2, companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).indexOf("\">"));
	String code = url.substring(url.indexOf("?s")+3);
	String descTemp = companies[i].substring(companies[i].indexOf(code+"\">"+code+"</a></td><td>")+15+code.length()*2);
	String desc = descTemp.substring(0,descTemp.indexOf("</td>"));
	stockDO.setUrl(url);
	stockDO.setCode(code);
	stockDO.setDesc(desc);
	URL oracle2 = new URL(url);
    BufferedReader in2 = new BufferedReader(new InputStreamReader(oracle2.openStream()));
    
    String inputLine2;
    String page2 = "";
    while ((inputLine2 = in2.readLine()) != null)
    {
    	page2= page2+"\n"+inputLine2;
    }
    String pageChopped = page2.substring(page2.indexOf("yfs_l84_"+code.toLowerCase()),page2.indexOf("%)</span>"));
//    System.out.println(pageChopped);
    double percent = Double.parseDouble(pageChopped.substring(pageChopped.indexOf("yfs_p43_"+code.toLowerCase()+"\">(")+("yfs_p43_"+code.toLowerCase()+"\">(").length()));
    if(pageChopped.contains("alt=\"Down\"")) {
    	percent = -percent;
    }
    double rate = Double.parseDouble(pageChopped.substring(pageChopped.indexOf(code.toLowerCase()+"\">")+(code.toLowerCase()+"\">").length(), pageChopped.indexOf("</span></span>")));
    stockDO.setRate(rate);
    stockDO.setPercentage(percent);
	stockDOList.add(stockDO);
}
        %>
  <TABLE border ="1">
  <TR><Th>Company Code</Th><Th>Company Description</Th><TH>Value</TH><TH>Percentage</TH></TR>
  <% for(StockDO stockDO: stockDOList)
  {
	  String color = "green";
if(stockDO.getPercentage()<0) color = "red"; 
	  %>
  <TR>
  <TD><%=stockDO.getCode() %></TD>
  <TD><%=stockDO.getDesc() %></TD>
  <TD><%=stockDO.getRate() %></TD>
  <TD><font color = <%=color %>><%=Math.abs(stockDO.getPercentage()) %></font></TD>
  </TR>
  <%} %>
  
  </TABLE>      
        
</body>
</html>