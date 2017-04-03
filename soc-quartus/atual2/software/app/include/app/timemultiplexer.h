class TimeMultilplexer {
public:
  void addObserver(Function* observer);
private:
  void timer_interrupt_handler() {
     observers[actualObserver](false);
     ++actualObserver>observers->size?actualObserver=0; //buffer circular
     observers[actualObserver](true);
  }
  unsigned short actualObserver;
  Function[]* observers;
}
