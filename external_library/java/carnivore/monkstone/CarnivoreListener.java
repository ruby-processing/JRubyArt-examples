package monkstone;

/*
* Best to use a package to avoid namespace clashes, create your own
*/
public interface CarnivoreListener {
  /*
  * @param packet the CarnivorePacket, a reflection method
  */
  public void packetEvent(org.rsg.carnivore.CarnivorePacket packet);  
}

