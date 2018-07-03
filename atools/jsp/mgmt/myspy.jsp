<%@ page contentType = "text/html;charset=GBK"%>
<%@ page import="java.net.MalformedURLException,java.net.URL,java.io.File,java.security.ProtectionDomain,java.security.CodeSource" %>
<%@ page import="java.lang.reflect.*"%>
<%@ page buffer="64kb"
         language = "java"
         session = "false"
         autoFlush = "true"
         isThreadSafe = "true"
         errorPage = "errorMsg.jsp"
%>
<%! static final String CLASS_VERSION = "$Id: dsjjspy.jsp,v 1.6 2008/03/13 05:45:16 i20496 Exp $";
	static final String _AppId = "执行后可观看输入之 class 所有内码资料";
	static int level = 0;
	static boolean type = true;
	static final String indentString = "  ";
  static String startTime=new java.util.Date(java.lang.management.ManagementFactory.getRuntimeMXBean().getStartTime()).toString();

	static String hrefClass(String className) {
		String titleName = className;
		if (className.startsWith("[L") && className.endsWith(";")) {
			titleName = className.substring(2, className.length() -1) + " []";
		}

		if (titleName.lastIndexOf(".") != -1) {
			titleName = titleName.substring(titleName.lastIndexOf(".") + 1);
		} else if (titleName.charAt(0) > 'a' && titleName.charAt(2) != 'j') {
			return "<font color=red>" + titleName + "</font>";
		}
		return (type) ? "<a href=?ClassName=" + className + ">" + titleName + "</a>": className;
	}

	static String indent() {
		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < level; ++i)
			sb.append(indentString);
		return sb.toString();
	}
	static String indent(String s) {
		return indent() + s;
	}

	public static String inspect(Class c) {
		StringBuffer sb = new StringBuffer();

		if (level == 0 ) {
			Package pkg = c.getPackage();
			if (pkg != null ) {
				sb.append(indent("package " + pkg.getName() + ";\n\n"));
			}
	  	}
		String mods = Modifier.toString(c.getModifiers());
		sb.append(indent());
		if (mods.length() > 0 ) {
			sb.append(mods).append(" ");

			if( !c.isArray() && !c.isInterface() && !c.isPrimitive()) {
				sb.append("class ");
			}
			sb.append(hrefClass(c.getName())).append("\r\n");

			//Get super class
			Class sup = c.getSuperclass();

			if( sup != null ) {
				++level;
				sb.append(indent("extends " + hrefClass(sup.getName()) + "\n"));
				--level;
			}

			//Get Interfaces
			Class[] interfaces = c.getInterfaces();

			if (interfaces.length > 0 ) {
				++level;

				for (int i = 0; i < interfaces.length; ++i) {
					sb.append(indent("implements " + hrefClass(interfaces[i].getName()) + "\n"));
				}
				--level;
			}

			//Start of class definition body
			sb.append(indent("{\n"));

			//Get Fields
			sb.append(processFields(c));

			//Get Constructors
			sb.append(processCtors(c));

			//GetMethods
			sb.append(processMethods(c));

			//Get Nested classes(recursive)
			Class[] classes = c.getDeclaredClasses();
			if( classes.length > 0 )
				++level;
			sb.append(indent("// Nested Classes\n"));
			for( int i = 0; i < classes.length; ++i)
				sb.append(inspect(classes[i]));
			--level;
		}
		//End of class definition body
		sb.append(indent("}\n"));
		return sb.toString();
	}

	static String processCtors(Class c) {
		StringBuffer sb = new StringBuffer();
		Constructor[] ctors = c.getDeclaredConstructors();

		if( ctors.length == 0 ) {
			return "";
		}
		++level;
		sb.append(indent("// Constructors 建构子\n"));

		for (int i = 0; i < ctors.length; ++i) {
			Constructor ctor = ctors[i];
			String mods = Modifier.toString(ctor.getModifiers());
			sb.append(indent());
			if(mods.length() > 0) {
				sb.append(mods).append(" ");
			}
			sb.append(hrefClass(ctor.getName())).append("(");
			//Print parameters
			sb.append(processParameters(ctor.getParameterTypes()));
			sb.append(");\r\n");
		}

		sb.append("\r\n");
		--level;
		return sb.toString();
	}

	static String processFields(Class c) {
		StringBuffer sb = new StringBuffer();
		Field[] fields = c.getDeclaredFields();

		if( fields.length == 0 ) {
			return "";
		}
		++level;
		sb.append(indent("// Fields 属性\n"));
		for( int i = 0; i < fields.length; ++i) {
			Field fld = fields[i];
			String type = fld.getType().getName();
			String mods = Modifier.toString(fld.getModifiers());
			sb.append(indent());

			if( mods.length() > 0 ) {
				sb.append(mods).append(" ");
			}
			sb.append(hrefClass(type)).append(" ").append(fld.getName()).append(";\r\n");
		}
		sb.append("\r\n");
		--level;
		return sb.toString();
	}

	static String processMethods(Class c) {
		StringBuffer sb = new StringBuffer();
		Method[] methods = c.getDeclaredMethods();
		if(methods.length == 0)
		  return "";
		++level;
		sb.append(indent("// Methods 函示\n"));
		for(int i = 0; i < methods.length; ++i) {
			Method m = methods[i];
			Class retType = m.getReturnType();
			String mods = Modifier.toString(m.getModifiers());
			sb.append(indent());
			if( mods.length() > 0) {
				sb.append(mods).append(" ");
			}
			sb.append(hrefClass(retType.getName())).append(" ").append(m.getName()).append("(");
			// Print parameters
			sb.append(processParameters(m.getParameterTypes()));
			sb.append(");\r\n");
		}
		sb.append("\r\n");
		--level;
		return sb.toString();
	}

	static String processParameters(Class[] parms) {
		StringBuffer sb = new StringBuffer();
		int nParms = parms.length;
		for( int i = 0; i < nParms; ++i) {
			Class parmType = parms[i];
			if(i > 0) {
				sb.append(", ");
			}
			sb.append(hrefClass(parmType.getName()));
		}
		return sb.toString();
	}

//

    /**
     * Given a Class object, attempts to find its .class location [returns null
     * if no such definition can be found]. Use for testing/debugging only.
     *
     * @return URL that points to the class definition [null if not found].
     */
    public static URL getClassLocation(final Class cls) {
        if (cls == null) throw new IllegalArgumentException("null input: cls");

        URL result = null;
        final String clsAsResource = cls.getName().replace('.', '/').concat(".class");

        final ProtectionDomain pd = cls.getProtectionDomain();
        // java.lang.Class contract does not specify if 'pd' can ever be null;
        // it is not the case for Sun's implementations, but guard against null
        // just in case:
        if (pd != null) {
            final CodeSource cs = pd.getCodeSource();
            // 'cs' can be null depending on the classloader behavior:
            if (cs != null) result = cs.getLocation();

            if (result != null) {
                // Convert a code source location into a full class file location
                // for some common cases:
                if ("file".equals(result.getProtocol())) {
                    try {
                        if (result.toExternalForm().endsWith(".jar") ||
                                result.toExternalForm().endsWith(".zip"))
                            result = new URL("jar:".concat(result.toExternalForm())
                                    .concat("!/").concat(clsAsResource));
                        else if (new File(result.getFile()).isDirectory())
                            result = new URL(result, clsAsResource);
                    } catch (MalformedURLException ignore) {
                    }
                }
            }
        }

        if (result == null) {
            // Try to find 'cls' definition as a resource; this is not
            // documented to be legal, but Sun's implementations seem to allow this:
            final ClassLoader clsLoader = cls.getClassLoader();

            result = clsLoader != null ?
                    clsLoader.getResource(clsAsResource) :
                    ClassLoader.getSystemResource(clsAsResource);
        }

        return result;
    }
    public String readCvsVersion(Class clazz) throws IllegalAccessException {
        Field field = null;
        try {
            field = clazz.getDeclaredField("CLASS_VERSION");
        } catch (NoSuchFieldException e) {
            return "<b>public final static String CLASS_VERSION</b> not defined !!" ;
        }
        return field.get(null).toString() ;
     }


%>
<%
	String msg  = "";
	String className =  request.getParameter("ClassName");
	String classLocationPath = "";
	String cvsVersion = "" ;
	try {
		if (className == null) {
			msg = (type) ? "<font color=red>请输入欲查询之 class 详细名称</font>" : "请输入欲查询之 class 详细名称";
			className = "";
		} else {
			Class clazz = Class.forName(className) ;
			cvsVersion = readCvsVersion(clazz)  ;
		}
	} catch (ClassNotFoundException cnfe) {
                cvsVersion=cnfe.toString();
		msg = (type) ? "<font color=red>" + cnfe.toString() + "</font>" :  cnfe.toString();
	}
%>
  <form method="post" action="myspy.jsp" name="form1">
    <tr>
      <td width="10%" class=subsys-title nowrap>版本</td>
      <td java><%=System.getProperty("com.icsc.serverName")%>-<%= cvsVersion %></td><td><%=startTime%></td>
    </tr>
  </form>
