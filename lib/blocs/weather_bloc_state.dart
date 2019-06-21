class BlocState<T> {
  T obj;
  Stats stats;
  String error;

  BlocState.success(this.obj) {
    this.stats = Stats.finishLoad;
  }

  BlocState.error(String error) {
    this.stats = Stats.error;
    this.error = error;
  }

  BlocState.loaded() {
    this.stats = Stats.loaded;
  }

  BlocState.loading() {
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
