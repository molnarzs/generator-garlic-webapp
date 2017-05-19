import { Log, Level } from 'ng2-logger'
import { Logger } from 'ng2-logger/src/logger'

export class LoggerFactory {
  log: Logger<{}>

  constructor(label: string, color = "black") {
    this.log = Log.create(label)
    this.log.color = color
  }

  DebugLog(target: Object, key: string, descriptor: TypedPropertyDescriptor<any>) {
    return {
      value: function (...args: any[]) {
        let result = descriptor.value.apply(this, args);
        this.log.d(`Call: ${target.constructor.name}.${key}`, {arguments: args});
        return result;
      }
    }
  }
}
