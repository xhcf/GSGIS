package cn.com.easy.down.server.export;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import org.apache.batik.transcoder.Transcoder;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.fop.svg.PDFTranscoder;

import cn.com.easy.down.server.PdfAddWaterMark;

public class PdfChartBySvgCode implements Strategy {

	@Override
	public String export(ArgsBean args) {
		String pdfFilePath=args.getDownPath() + args.getUuid() + ".pdf";
		String outputFilePath = args.getDownPath() + args.getUuid() + "_.pdf";
		//svgCode = "<svg xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns=\"http://www.w3.org/2000/svg\" width=\"600\" height=\"400\" version=\"1.1\"><desc>Created with Highcharts 3.0.7</desc><defs><clipPath id=\"highcharts-7\"><rect fill=\"none\" x=\"1\" y=\"0\" width=\"288\" height=\"513\" /></clipPath></defs><rect fill=\"#ffffff\" x=\"0\" y=\"0\" width=\"600\" height=\"400\" rx=\"0\" ry=\"0\" /><g class=\"highcharts-grid\"  /><g class=\"highcharts-grid\" ><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 123.5 59 L 123.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 169.5 59 L 169.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 216.5 59 L 216.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 263.5 59 L 263.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 309.5 59 L 309.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 356.5 59 L 356.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 402.5 59 L 402.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 449.5 59 L 449.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 496.5 59 L 496.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 542.5 59 L 542.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 590.5 59 L 590.5 348\"  /><path opacity=\"1\" fill=\"none\" stroke=\"#c0c0c0\" stroke-width=\"1\" d=\"M 76.5 59 L 76.5 348\"  /></g><g class=\"highcharts-axis\" ><path opacity=\"1\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"1\" d=\"M 77 260.5 L 72 260.5\" /><path opacity=\"1\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"1\" d=\"M 77 175.5 L 72 175.5\" /><path opacity=\"1\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"1\" d=\"M 77 90.5 L 72 90.5\" /><path opacity=\"1\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"1\" d=\"M 77 345.5 L 72 345.5\" /><text visibility=\"visible\" style=\"color: rgb(77, 117, 158); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: bold; fill: #4d759e;\" text-anchor=\"middle\" transform=\"translate(0) rotate(270 28.38 203.5)\" x=\"28.38\" y=\"203.5\" ><tspan x=\"28.38\">Altitude</tspan></text><path visibility=\"visible\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"1\" d=\"M 76.5 59 L 76.5 348\"  /></g><g class=\"highcharts-axis\" ><text visibility=\"visible\" style=\"color: rgb(77, 117, 158); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: bold; fill: #4d759e;\" text-anchor=\"middle\" transform=\"translate(0)\" x=\"333.5\" y=\"379\" ><tspan x=\"333.5\">Temperature</tspan></text><path visibility=\"visible\" fill=\"none\" stroke=\"#c0d0e0\" stroke-width=\"2\" d=\"M 77 348 L 590 348\"  /></g><g class=\"highcharts-series-group\" ><g class=\"highcharts-series\" visibility=\"visible\" clip-path=\"url(#highcharts-7)\" transform=\"translate(590 348) rotate(90) scale(-1 1) scale(1)\"  width=\"513\" height=\"289\"><path fill=\"none\" stroke=\"#2f7ed8\" stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M 2.72642 23.3182 C 2.72642 23.3182 23.1745 296.141 36.8066 326.455 C 50.4387 356.768 57.2547 356.768 70.8868 356.768 C 84.5189 356.768 91.3349 342.218 104.967 310.132 C 118.599 278.046 125.415 237.379 139.047 196.339 C 152.679 155.299 159.495 104.932 173.127 104.932 C 186.759 104.932 193.575 172.834 207.208 222.455 C 220.84 272.077 227.656 307.52 241.288 353.037 C 254.92 398.554 275.368 450.041 275.368 450.041\"  /><path class=\" highcharts-tracker\" visibility=\"visible\" fill=\"none\" stroke=\"rgb(192, 192, 192)\" stroke-linejoin=\"round\" stroke-opacity=\"0.0001\" stroke-width=\"22\" d=\"M -7.27358 23.3182 L 2.72642 23.3182 C 2.72642 23.3182 23.1745 296.141 36.8066 326.455 C 50.4387 356.768 57.2547 356.768 70.8868 356.768 C 84.5189 356.768 91.3349 342.218 104.967 310.132 C 118.599 278.046 125.415 237.379 139.047 196.339 C 152.679 155.299 159.495 104.932 173.127 104.932 C 186.759 104.932 193.575 172.834 207.208 222.455 C 220.84 272.077 227.656 307.52 241.288 353.037 C 254.92 398.554 275.368 450.041 275.368 450.041 L 285.368 450.041\"  /></g><g class=\"highcharts-markers highcharts-tracker\" visibility=\"visible\" clip-path=\"none\" transform=\"translate(590 348) rotate(90) scale(-1 1) scale(1)\"  width=\"513\" height=\"289\"><path fill=\"#2f7ed8\" d=\"M 275 446.041 C 280.328 446.041 280.328 454.041 275 454.041 C 269.672 454.041 269.672 446.041 275 446.041 Z\" /><path fill=\"#2f7ed8\" d=\"M 241 349.037 C 246.328 349.037 246.328 357.037 241 357.037 C 235.672 357.037 235.672 349.037 241 349.037 Z\" /><path fill=\"#2f7ed8\" d=\"M 207 218.455 C 212.328 218.455 212.328 226.455 207 226.455 C 201.672 226.455 201.672 218.455 207 218.455 Z\" /><path fill=\"#2f7ed8\" d=\"M 173 100.932 C 178.328 100.932 178.328 108.932 173 108.932 C 167.672 108.932 167.672 100.932 173 100.932 Z\" /><path fill=\"#2f7ed8\" d=\"M 139 192.339 C 144.328 192.339 144.328 200.339 139 200.339 C 133.672 200.339 133.672 192.339 139 192.339 Z\" /><path fill=\"#2f7ed8\" d=\"M 104 306.132 C 109.328 306.132 109.328 314.132 104 314.132 C 98.672 314.132 98.672 306.132 104 306.132 Z\" /><path fill=\"#2f7ed8\" d=\"M 70 352.768 C 75.328 352.768 75.328 360.768 70 360.768 C 64.672 360.768 64.672 352.768 70 352.768 Z\" /><path fill=\"#2f7ed8\" d=\"M 36 322.455 C 41.328 322.455 41.328 330.455 36 330.455 C 30.672 330.455 30.672 322.455 36 322.455 Z\" /><path fill=\"#2f7ed8\" d=\"M 2 19.3182 C 7.328 19.3182 7.328 27.3182 2 27.3182 C -3.328 27.3182 -3.328 19.3182 2 19.3182 Z\" /></g></g><text class=\"highcharts-title\" style=\"color: rgb(39, 75, 109); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 16px; fill: #274b6d;\" text-anchor=\"middle\" x=\"300\" y=\"25\" ><tspan x=\"300\">Atmosphere Temperature by Altitude</tspan></text><text class=\"highcharts-subtitle\" style=\"color: rgb(77, 117, 158); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 12px; fill: #4d759e;\" text-anchor=\"middle\" x=\"300\" y=\"40\" ><tspan x=\"300\">According to the Standard Atmosphere Model</tspan></text><g class=\"highcharts-axis-labels\" ><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"end\" x=\"69\" y=\"350.2736\"><tspan x=\"69\">0km</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"end\" x=\"69\" y=\"265.0731\"><tspan x=\"69\">25km</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"end\" x=\"69\" y=\"179.8726\"><tspan x=\"69\">50km</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"end\" x=\"69\" y=\"94.6722\"><tspan x=\"69\">75km</tspan></text></g><g class=\"highcharts-axis-labels\" ><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"77\" y=\"362\"><tspan x=\"77\">-90月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"123.6364\" y=\"362\"><tspan x=\"123.6364\">-80月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"170.2727\" y=\"362\"><tspan x=\"170.2727\">-70月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"216.9091\" y=\"362\"><tspan x=\"216.9091\">-60月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"263.5455\" y=\"362\"><tspan x=\"263.5455\">-50月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"310.1818\" y=\"362\"><tspan x=\"310.1818\">-40月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"356.8182\" y=\"362\"><tspan x=\"356.8182\">-30月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"403.4546\" y=\"362\"><tspan x=\"403.4546\">-20月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"450.0909\" y=\"362\"><tspan x=\"450.0909\">-10月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"496.7273\" y=\"362\"><tspan x=\"496.7273\">0月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"543.3637\" y=\"362\"><tspan x=\"543.3637\">10月</tspan></text><text style=\"color: rgb(102, 102, 102); line-height: 14px; font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 11px; cursor: default; fill: #666;\" opacity=\"1\" text-anchor=\"middle\" x=\"590\" y=\"362\"><tspan x=\"590\">20月</tspan></text></g><g class=\"highcharts-tooltip\" style=\"padding: 0px; white-space: nowrap; cursor: default;\" transform=\"translate(0 -999)\" ><rect fill=\"none\" fill-opacity=\"0.85\" stroke=\"black\" stroke-opacity=\"0.05\" stroke-width=\"5\" transform=\"translate(1 1)\" x=\"0.5\" y=\"0.5\" width=\"16\" height=\"16\" rx=\"3\" ry=\"3\"  /><rect fill=\"none\" fill-opacity=\"0.85\" stroke=\"black\" stroke-opacity=\"0.1\" stroke-width=\"3\" transform=\"translate(1 1)\" x=\"0.5\" y=\"0.5\" width=\"16\" height=\"16\" rx=\"3\" ry=\"3\"  /><rect fill=\"none\" fill-opacity=\"0.85\" stroke=\"black\" stroke-opacity=\"0.15\" stroke-width=\"1\" transform=\"translate(1 1)\" x=\"0.5\" y=\"0.5\" width=\"16\" height=\"16\" rx=\"3\" ry=\"3\"  /><rect fill=\"rgb(255, 255, 255)\" fill-opacity=\"0.85\" x=\"0.5\" y=\"0.5\" width=\"16\" height=\"16\" rx=\"3\" ry=\"3\" /><text style=\"color: rgb(51, 51, 51); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 12px; fill: #333333;\" x=\"8\" y=\"21\"  /></g><text style=\"color: rgb(144, 144, 144); font-family: 'lucida grande', 'lucida sans unicode', verdana, arial, helvetica, sans-serif; font-size: 9px; cursor: pointer; fill: #909090;\" text-anchor=\"end\" x=\"590\" y=\"395\" ><tspan x=\"590\">Highcharts.com</tspan></text></svg>";
		BufferedOutputStream outBufferOutputStream=null;
		OutputStream outputStream = null;
		ByteArrayInputStream inputStream=null;
		File file = new File(outputFilePath);
		try {
			byte[] bytes = args.getSvgCode().getBytes("UTF-8");
			outputStream = new FileOutputStream(file);
			outBufferOutputStream = new BufferedOutputStream(outputStream);  
			inputStream=new ByteArrayInputStream(bytes);
			Transcoder transcoder = new PDFTranscoder();  
			TranscoderInput input = new TranscoderInput(inputStream);  
		    TranscoderOutput output = new TranscoderOutput(outBufferOutputStream);  
		    transcoder.transcode(input, output);
		    if(args.getMarkInfo() != null){
				PdfAddWaterMark mark = new PdfAddWaterMark();
				args.getMarkInfo().put("srcpdf", outputFilePath);
				args.getMarkInfo().put("destpdf", pdfFilePath);
				mark.addTextMark(args.getMarkInfo());
				
				File tempfile = new File(outputFilePath);
				if (tempfile.exists()) {
					tempfile.delete();
				}
			}else{
				file = new File(outputFilePath);
				File pdfFile=new File(pdfFilePath);
				file.renameTo(pdfFile);
			}

		} catch (Exception e) {
			outputFilePath = "";
			e.printStackTrace();
		}finally{
			if (outBufferOutputStream != null) {
				try {
					outBufferOutputStream.close();
				} catch (IOException e) {
					System.err.println("createPdfChartBySvgCode:关闭缓冲输出流出错！");
					e.printStackTrace();
				}
			}
			if (outputStream != null) {
				try {
					outputStream.close();
				} catch (IOException e) {
					System.err.println("createPdfChartBySvgCode:关闭输出流出错！");
					e.printStackTrace();
				}
			}
			if(inputStream!=null){
				try {
					inputStream.close();
				} catch (IOException e) {
					System.err.println("createPdfChartBySvgCode:关闭输入流出错！");
					e.printStackTrace();
				}
			}
		} 
		return pdfFilePath;
	}
}