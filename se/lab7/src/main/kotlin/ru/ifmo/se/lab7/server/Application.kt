package ru.ifmo.se.lab7.server

import ru.ifmo.se.lab7.server.ui.MainFrame
import ru.ifmo.se.lab7.server.ui.StartupDialog
import java.awt.EventQueue
import java.net.ServerSocket
import java.util.concurrent.PriorityBlockingQueue
import kotlin.concurrent.thread

/* "The head of the queue is the least element with respect to the specified ordering",
 * which doesn't make much sense in our case, hence the flipped comparator. */
@JvmField val QUEUE_COMPARATOR: Comparator<EmploymentRequest> =
  Comparator.naturalOrder<EmploymentRequest>().reversed()

@JvmField val AUTH_TABLE: Map<String, String> =
  mapOf("test" to Authenticator.passwordHash("test"))

fun main(args: Array<String>) {
  val runner = CommandRunner(EmploymentRequestCommands.commandList,
    PriorityBlockingQueue(16, QUEUE_COMPARATOR))

  EventQueue.invokeLater {
    StartupDialog().addSetupFinishListener(object : StartupDialog.SetupFinishEventListener {
      override fun onSetupFinish(e: StartupDialog.SetupFinishEvent) {
        launchServerThread(e.port, runner)
        showMainWindow(e.user)
      }
    })
  }
}

fun showMainWindow(user: String) =
  EventQueue.invokeLater { MainFrame(user) }

fun launchServerThread(port: Int, runner: CommandRunner<EmploymentRequest>) = thread {
  ServerSocket(port).use {
    println("The server is now ready to accept connections.")
    while (true) {
      val client = it.accept()
      thread { RequestHandler(client, runner).run() }
    }
  }
}
