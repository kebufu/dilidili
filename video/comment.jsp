<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.zip.GZIPInputStream"%>
<%!
    public static byte[] read(DataInputStream stream,int length) throws Exception{
        byte[] data=new byte[length];
        stream.readFully(data);
        return data;
    }
    public static byte[] uncompress(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            return null;
        }
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ByteArrayInputStream in = new ByteArrayInputStream(bytes);
        try {
            GZIPInputStream ungzip = new GZIPInputStream(in);
            byte[] buffer = new byte[256];
            int n;
            while ((n = ungzip.read(buffer)) >= 0) {
                out.write(buffer, 0, n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out.toByteArray();
    }
%>
<meta charset="utf-8">
<script type="text/javascript">
    function clear(){for (var i in window) {
        if (i!="location") {eval("delete "+i);delete window[i];window[i]=null;eval(i+"=null");}
    }}
    //setInterval(clear,10000)
</script>
<p>公告:如果要我添加某个视频，请<font color="#ff0000">务必</font>附带视频文件，除非没有 <a href="comment.txt">旧留言板</a></p>
<hr/>
<%response.setCharacterEncoding("utf-8");
long number=1;
DataInputStream in = new DataInputStream(new FileInputStream("../webapps/video/comment.bin"));
try {
    while(true) {
        int length = in.readInt();
        byte[] temp=uncompress(read(in,length));
        DataInputStream data = new DataInputStream(new ByteArrayInputStream(temp));
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(data.readLong()));
        String username = new String(read(data,data.readInt()),"UTF-8");
        String comment = new String(read(data,data.readInt()),"UTF-8").replaceAll("\n","<br/>");
        out.println("<div><div style=\"float:left\"><font color=\"#0000ff\">"+number+"# </font>"+username+"</div><div style=\"float:right\">"+date+"</div></div><div style=\"clear:both\"></div>");
        out.println("<div>"+comment+"</div>\n<hr/>");
        number++;
    }
} catch(Exception e) {
    ;
} finally {
    in.close();
}
%>