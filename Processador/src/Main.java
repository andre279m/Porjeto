import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * args[0] = metricas.txt
 * args[1] = dataset.csv
 * args[2] = Agregador/Main
 */

public class Main {
	public static void main(String[] args) throws IOException{
		Map<Long,String> outputTable = new HashMap<>();	

		java.nio.file.Files.lines(Paths.get(args[0])).forEach (metric -> {
			ProcessWrapper processor1 = new ProcessWrapper(args[2]);
			processor1.writeLine(metric);
			AtomicLong counter = new AtomicLong(0);
			try {
				java.nio.file.Files.lines(Paths.get(args[1])).forEach(line -> {
					processor1.writeLine(line.replace(",", " "));
					String outputPorMetrica = processor1.readLine();
					if (!outputTable.containsKey(counter.get()))
						outputTable.put(counter.get(), outputPorMetrica);
					else
						outputTable.replace(counter.get(), outputTable.get(counter.get()) + "," + outputPorMetrica);
					counter.getAndIncrement();
				});
			} catch (IOException e) {
				e.printStackTrace();
			}
			processor1.kill();
		});
		
		for(String lines : outputTable.values()){
			System.out.println(lines);
		}
		
	}
	
}
