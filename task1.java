class First {
    
    void getClassname() {
        System.out.println("First");
    }
    
    void getLetter(Object obj) {
        if (obj instanceof Second) {
            System.out.println("B");
        } 
            else {
               System.out.println("A");
            }
    }
    
}

class Second extends First {
     void getClassname() {
        System.out.println("Second");
    }
}

public class Main
{
	public static void main(String[] args) {
	    First first_obj = new First();
	    Second second_obj = new Second();
	    first_obj.getClassname();
	    first_obj.getLetter(first_obj);
	    second_obj.getClassname();
	    second_obj.getLetter(second_obj);
	}
}
