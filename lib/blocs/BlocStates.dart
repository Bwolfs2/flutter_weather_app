
class BlocStates<T> {
  T obj;
  Stats stats;
  String error;

  BlocStates.success(this.obj) {
    this.stats = Stats.finishLoad;
  }

  BlocStates.error(String error) {
    this.stats = Stats.error;
    this.error = error;
  }

  BlocStates.loaded() {
    this.stats = Stats.loaded;
  }

  BlocStates.loading() {
    this.stats = Stats.loading;
  }

  bool isSuccess() {
    return this.stats == Stats.finishLoad;
  }

  bool hasError() {
    return this.stats == Stats.finishLoad;
  }

  bool isLoaded() {
    return this.stats == Stats.loaded;
  }
}

enum Stats { loading, finishLoad, error, loaded }
