package com.crawler;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class URLReader {
    public static void main(String[] args) throws Exception {

        URL oracle = new URL("http://finance.yahoo.com/lookup/stocks;_ylt=AhW41_lOscQ5gL0KaBzztULXVax_;_ylu=X3oDMTFiM3RzMzF1BHBvcwMyBHNlYwN5ZmlTeW1ib2xMb29rdXBSZXN1bHRzBHNsawNzdG9ja3M-?s=%5Ea&t=S&m=ALL&r=");
        BufferedReader in = new BufferedReader(
        new InputStreamReader(oracle.openStream()));
        
        String inputLine;
        String page = "";
        while ((inputLine = in.readLine()) != null)
        {
        	page= page+"\n"+inputLine;
        }
        String stocks = page.substring(page.indexOf("Exchange</a></th></tr></thead><tbody>")+37,page.indexOf("</tbody></table></div><div id=\"pagination\">"));
        in.close();
        List<StockDO> stockDOList = new ArrayList<StockDO>();
        String[] companies = stocks.split("</tr>");
        HashMap<String,String> map = new HashMap<String,String>();
        
        for(int i=0;i<companies.length;i++){
//        	System.out.println(companies[i]);
        	StockDO stockDO = new StockDO();
        	String url = companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).substring(companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).indexOf("=\"")+2, companies[i].substring(companies[i].indexOf("<a"),companies[i].indexOf("</a>")).indexOf("\">"));
        	String code = url.substring(url.indexOf("?s")+3);
        	String descTemp = companies[i].substring(companies[i].indexOf(code+"\">"+code+"</a></td><td>")+15+code.length()*2);
        	String desc = descTemp.substring(0,descTemp.indexOf("</td>"));
        	stockDO.setUrl(url);
        	stockDO.setCode(code);
        	stockDO.setDesc(desc);
        	stockDOList.add(stockDO);
        	System.out.println(desc);
        }
        
        
        StockDO stockDO = new StockDO();
//        stockDO.setLink(link)
         
        
    }
}
