#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  MPI_Init(0, 0);

  int WorldRank;
  MPI_Comm_rank(MPI_COMM_WORLD, &WorldRank);

  int WorldSize;
  MPI_Comm_size(MPI_COMM_WORLD, &WorldSize);

  if (WorldSize != 2) {
    std::cout << "Needs WorldSize of 2" << std::endl;
    return -1;
  }

  if (WorldRank == 0) {
    char buffer[] = {'h', 'e', 'l', 'l', 'o'};

    MPI_Send(buffer, strlen(buffer), MPI_CHAR, 1, 0, MPI_COMM_WORLD);
    std::cout << "Sent: " << buffer << " to 1." << std::endl;
  } else {
    MPI_Status status;
    int amountSent;

    MPI_Probe(0, 0, MPI_COMM_WORLD, &status);
    MPI_Get_count(&status, MPI_CHAR, &amountSent);

    char* buffer = reinterpret_cast<char*>(malloc(sizeof(char) * amountSent));
    memset(buffer, 0, sizeof buffer);

    MPI_Recv(buffer, sizeof buffer, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    std::cout << "Got: " << buffer << " from 0." << std::endl;
    free(buffer);
  }

  MPI_Finalize();
  return 0;
}

