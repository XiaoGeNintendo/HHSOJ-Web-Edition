

/**
 * Load java class
 * @author XGN
 *
 */
public class JavaClassLoader extends ClassLoader {
	public Class<?> loadClass(byte[] classFile, String className) {
		Class<?> cla = super.defineClass(className, classFile, 0, classFile.length);
		return cla;
	}
}